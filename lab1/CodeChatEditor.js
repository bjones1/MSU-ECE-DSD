// <h1><code>CodeChatEditor.js</code> &mdash; JavaScript which implements the CodeChat Editor</h1>
//
// The CodeChat Editor provides a simple IDE which allows editing of mixed code and doc blocks.
//
"use strict";

// <h2>DOM ready event</h2>
//
// <p>This code instantiates editors/viewers for code and doc blocks.
const on_load = (currentScript) => {
    tinymce.init({
        inline: true,
        plugins: 'advlist anchor charmap emoticons image link lists media nonbreaking quickbars searchreplace visualblocks visualchars table',
        // When true, this still prevents hyperlinks to anchors on the current page from working correctly. There's an onClick handler that prevents links in the current page from working -- need to look into this. See also <a href="https://github.com/tinymce/tinymce/issues/3836">a related GitHub issue</a>.
        //readonly: true,
        selector: '.CodeChat-TinyMCEx',
        toolbar: 'numlist bullist',
    });

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
};

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
//
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

const on_save_as = async () => {
    // Get the filename and path from the HTML title -- currently, that's where <code>CodeToEditor.py</code> puts it. In the future, use an open dialog/drag-n-drop area.
    const filename = document.getElementsByTagName("title")[0].getAttribute("data-CodeChat-filename")
    // There's no way to use this currently, because of security concerns.
    //const path = document.title.getAttribute("data-CodeChat-path")

    // Save it to a local file. The following comes from a <a href="https://web.dev/file-system-access/#ask-the-user-to-pick-a-file-to-read">helpful tutorial</a>.
    source_code_file_handle = await self.showSaveFilePicker({
        suggestedName: filename,
    });
    await on_save();

    // The Save button now works.
    document.getElementById("CodeChat-save-button").disabled = false;
}

const on_save = async () => {
    // This is the data to write &mdash; the source code.
    const source_code = editor_to_source_code("//");

    // Create a FileSystemWritableFileStream to write to.
    const writable = await source_code_file_handle.createWritable();
    await writable.write(source_code);
    // Close the file and write the contents to disk. <em>Important</em>: the write is only performed <em>after</em> the file is closed!
    await writable.close();
}