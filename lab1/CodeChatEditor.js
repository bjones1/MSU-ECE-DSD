// <h1><code>CodeChatEditor.js</code> &mdash; JavaScript which implements the CodeChat Editor</h1>
//
// The CodeChat Editor provides a simple IDE which allows editing of mixed code and doc blocks.
//
"use strict";

// <h2>DOM ready event</h2>
//
// <p>This code instantiates editors/viewers for code and doc blocks.
const on_load = (currentScript) => {
    // Instantiate the TinyMCE editor for doc blocks.
    tinymce.init({
        inline: true,
        plugins: 'advlist anchor charmap emoticons image link lists media nonbreaking quickbars searchreplace visualblocks visualchars table',
        // When true, this still prevents hyperlinks to anchors on the current page from working correctly. There's an onClick handler that prevents links in the current page from working -- need to look into this. See also <a href="https://github.com/tinymce/tinymce/issues/3836">a related GitHub issue</a>.
        //readonly: true,
        relative_urls: true,
        selector: '.CodeChat-TinyMCEx',
        toolbar: 'numlist bullist',

        // <h3>Settings for plugins</h3>
        // <h4><a href="https://www.tiny.cloud/docs/plugins/opensource/image/">Image</a></h4>
        image_caption: true,
        image_advtab: true,
        image_title: true,
    });

    // Instantiate the Ace editor for code blocks.
    ace.config.set('basePath', 'https://cdnjs.cloudflare.com/ajax/libs/ace/1.9.5');
    for (const ace_tag of document.querySelectorAll(".CodeChat-ACE")) {
        ace.edit(ace_tag, {
            // The leading <code>+</code> converts the line number from a string (since all HTML attributes are strings) to a number.
            firstLineNumber: +ace_tag.getAttribute("data-CodeChat-firstLineNumber"),
            highlightActiveLine: false,
            highlightGutterLine: false,
            maxLines: 1e10,
            // <span id="script-param">A convenient way to <a href="CodeToEditor.py#script-param">pass data</a> from the HTML <code>&lt;script&gt;</code> tag to the currently-executing script.</span>
            mode: `ace/mode/${currentScript.getAttribute("data-CodeChat-language-name")}`,
            // TODO: this still allows cursor movement.
            readOnly: true,
            showPrintMargin: false,
            theme: "ace/theme/textmate",
            wrap: true,
        });
    }

    // Set up for editing the indent of doc blocks.
    for (const td of document.querySelectorAll(".CodeChat-doc-indent")) {
        td.addEventListener("beforeinput", doc_block_indent_on_before_input);
        td.addEventListener("input", doc_block_indent_on_input);
    }
};


// <h3>Doc block indent editor</h3>
// <p>Allow only spaces and delete/backspaces when editing the indent of a doc block.</p>
const doc_block_indent_on_before_input = event => {
    // Only modify the behavior of inserts.
    if (event.data) {
        // Block any insert that's not an insert of spaces.
        if (event.data !== " ".repeat(event.data.length)) {
            event.preventDefault();
        }
    }
}


// After an edit, the editor by default changes some non-breaking spaces into normal spaces. Undo this, since it breaks the layout. This is because normal spaces wrap, while non-breaking spaces don't; we need no wrapping to correctly set the indent.
const doc_block_indent_on_input = event => {
    // Save the current cursor position. Setting <code>innerHTML</code> loses it.
    const offset = window.getSelection().anchorOffset;
    // Replace any spaces with non-breaking spaces.
    event.currentTarget.innerHTML = event.currentTarget.innerHTML.replaceAll(" ", "&nbsp;");
    // Restore the current cursor position -- an offset into the text node inside this <code>&lt;tr&gt; element.
    window.getSelection().setBaseAndExtent(event.currentTarget.childNodes[0], offset, event.currentTarget.childNodes[0], offset);
}

// <p>From <a href="https://developer.mozilla.org/en-US/docs/Web/API/Document/DOMContentLoaded_event#checking_whether_loading_is_already_complete">MDN</a>.</p>
//
// <p>Loading hasn't finished yet.</p>
if (document.readyState === 'loading') {
    // Save the <code>currentScript</code> now, since it will be <code>null</code> when the event is fired.
    const cs = document.currentScript;
    document.addEventListener('DOMContentLoaded', () => on_load(cs));
} else {
    // <code>DOMContentLoaded</code> has already fired.
    on_load(document.currentScript);
}

// <h2>Transforming the editor's contents back to code</h2>
// <p>This transforms the current editor contents into source code.</p>
const editor_to_source_code = (
    // A string specifying the comment character(s) for the current programming language. A space will be added after this string before appending a line of doc block contents.
    comment_string
) => {
    // Walk through each code and doc block, extracting its contents then placing it in <code>classified_lines</code>.
    let classified_lines = [];
    for (const code_or_doc_tag of document.querySelectorAll(".CodeChat-ACE, .CodeChat-TinyMCE")) {
        // The type of this block: -1 for code, or >= 0 for doc (the value of n specifies the indent in spaces).
        let type_;
        // A string containing all the code/docs in this block.
        let full_string;

        // Get the type of this block and its contents.
        if (code_or_doc_tag.classList.contains("CodeChat-ACE")) {
            type_ = -1;
            full_string = ace.edit(code_or_doc_tag).getValue();
        } else if (code_or_doc_tag.classList.contains("CodeChat-TinyMCE")) {
            // Get the indent from the previous table cell.
            const indent_html = code_or_doc_tag.parentElement.previousElementSibling.innerHTML;
            type_ = indent_html.replaceAll("&nbsp;", " ").length;
            // See <a href="https://www.tiny.cloud/docs/tinymce/6/apis/tinymce.root/#get"><code>get</code></a> and <a href="https://www.tiny.cloud/docs/tinymce/6/apis/tinymce.editor/#getContent"><code>getContent()</code></a>. Fortunately, it looks like TinyMCE assigns a unique ID if one's no provided, since it only operates on an ID instead of the element itself.
            full_string = tinymce.get(code_or_doc_tag.id).getContent();
            // The HTML from TinyMCE is a mess! Wrap at 80 characters, including the length of the indent and comment string.
            full_string = html_beautify(full_string, { "wrap_line_length": 70 });
        } else {
            console.assert(false, `Unexpected class for code or doc block ${code_or_doc_tag}.`);
        }

        // Split the <code>full_string</code> into individual lines; each one corresponds to an element of <code>classified_lines</code>.
        for (const string of full_string.split(/\r?\n/)) {
            classified_lines.push([type_, string + "\n"]);
        }
    }

    // Transform these classified lines into source code.
    let lines = [];
    for (const [type_, string] of classified_lines) {
        if (type_ === -1) {
            // Just dump code out!
            lines.push(string);
        } else {
            // <p>Prefix comments with the indent and the comment string.</p>
            //
            // <p>TODO: allow the use of block comments.</p>
            lines.push(`${" ".repeat(type_)}${comment_string} ${string}`);
        }
    }

    return lines.join("");
};


// <h2>UI</h2>
// <p>Store the file handle for saves (and eventually opens) here.</p>
let source_code_file_handle;

// Get the filename and path from the HTML title -- currently, that's where <code>CodeToEditor.py</code> puts it. In the future, use an open dialog/drag-n-drop area.
const get_filename = () => {
    const filename = document.getElementsByTagName("title")[0].getAttribute("data-CodeChat-filename");
    const extension = filename.split(".").pop();
    return [filename, extension];
}


const on_save_as = async () => {
    const [filename, extension] = get_filename();
    // There's no way to use this currently.
    //const path = document.title.getAttribute("data-CodeChat-path")

    // Save it to a local file. The following comes from a <a href="https://web.dev/file-system-access/#ask-the-user-to-pick-a-file-to-read">helpful tutorial</a>.
    source_code_file_handle = await self.showSaveFilePicker({
        suggestedName: filename,
    });
    await on_save();

    // The Save button now works.
    document.getElementById("CodeChat-save-button").disabled = false;
}


// TODO: many missing mappings!
const file_extension_to_comment = {
    c: "//",
    cpp: "//",
    cc: "//",
    js: "//",
    py: "#",
    // Verilog.
    v: "//",
    // Xilinx pin constraints file.
    xdc: "#",
}

const on_save = async () => {
    const [filename, extension] = get_filename();
    const comment = file_extension_to_comment[extension];
    // This is the data to write &mdash; the source code.
    const source_code = editor_to_source_code(comment);

    // Create a FileSystemWritableFileStream to write to.
    const writable = await source_code_file_handle.createWritable();
    await writable.write(source_code);
    // Close the file and write the contents to disk. <em>Important</em>: the write is only performed <em>after</em> the file is closed!
    await writable.close();
}