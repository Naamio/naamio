# Directory Structure

`Naamio` has, within it, a text transformation engine. 
The concept behind the system is this: you give it text 
written in your favorite markup language, be that Markdown, 
Stencil, or just plain XHTML, and it churns that through a 
layout or a series of layout files. 

Throughout that process you can tweak how you want the 
site URLs to look, what data gets displayed in the 
layout, and more. This is all done through editing text
files; the resulting web application is the final product.

A basic Naamio site usually looks something like this (with
a little inspiration from Jekyll's documentation):

```
    .
    ├── naamio.yml
    ├── _data
    |   └── members.yml
    ├── _drafts
    |   ├── begin-with-the-crazy-ideas.md
    |   └── on-simplicity-in-technology.md
    ├── _pages
    |   └── index.html
    ├── _posts
    |   ├── 2007-10-29-why-every-programmer-should-play-nethack.md
    |   └── 2009-04-26-barcamp-boston-4-roundup.md
    ├── assets
    |   ├── scripts
    |   |   ├── js
    |   |   |   ├── d3.js
    |   |   |   └── mail.js
    |   |   └── ts
    |   |       ├── app.ts
    |   |       └── branding.ts
    |   ├── images
    |   |   ├── rasters
    |   |   └── vectors
    |   └── styles
    |       ├── css
    |       |   ├── base.css
    |       |   └── screen.css
    |       └── fonts
    ├── stencils
    |       ├── layouts
    |       |   ├── default.html
    |       |   └── post.html
    |       ├── partials
    |       |   ├── footer.html
    |       |   └── header.html
    |       ├── home.html
    |       └── contact.html
    └── .metadata
```

Folders prefixed with underscores (`_`) are intended to be used for raw 
original data, where as folders prefixed with periods (`.`) are intended
to be ignored by source code repositories and have generated content within
them from `Naamio`.

Note: `Naamio` differs from static site generators like Jekyll significantly, 
and although it offers some similar features to these static site generators,
it also takes features from dynamic content projects, such as WordPress or 
Ghost, to deliver a performant, rich, and dynamic application platform, 
whilst staying as true to its mission of being simple as possible.

`Naamio` intends to optimize assets, such as JavaScript, Cascading Style Sheets,
rasters, and vectors. Therefore, providing those within the template will enable 
`Naamio` to run optimization routines on the assets dynamically based on demand.
In this way, `Naamio` differs from other site generators and hosts where optimizations
are commonly made prior to deployment, based on the designer's assumptions.

Where optimizations cannot currently be made, namely in pre-compilation 
of sources, such as LESS, SASS, and TypeScript, `Naamio` still supports 
the addition of such sources into the repository and will ensure that those
sources are treated as "raw", and are thus ignored.

An overview of each of these folders and files is as follows:

<table>
    <tr>
        <th>File / Directory</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>_config.yml</td>
        <td>
            Stores configuration data. Many of these options can be 
            specified from the command line executable but it’s easier 
            to specify them here so you don’t have to remember them.
        </td>
    </tr>
    <tr>
        <td>_data</td>
        <td>
            Well-formatted site data should be placed here. The <code>Naamio</code>
            engine will autoload all data files in this directory.
        </td>
    </tr>
    <tr>
        <td>_drafts</td>
        <td>
            Drafts are unpublished posts. The format of these files 
            is without a date: title.MARKUP. Learn how to work with drafts. 
        </td>
    </tr>
    <tr>
        <td>_pages</td>
        <td>
            Anything placed within the `_pages` directory is retained
            structurally. Markdown and Stencil files will be processed,
            and then hosted statically by <code>Naamio</code> at the 
            root (<code>/</code>) of the application.
        </td>
    </tr>
    <tr>
        <td>_posts</td>
        <td>
            Your dynamic content, so to speak. The naming convention of 
            these files is important, and must follow the format: 
            <code>YEAR-MONTH-DAY-title.MARKUP</code>. The permalinks can be 
            customized for each post, but the date and markup language 
            are determined solely by the file name. 
        </td>
    </tr>
    <tr>
        <td>themes</td>
        <td>
            The themes folder allows the designer to select a single
            theme when running <code>Naamio</code>. If only one theme exists within
            this folder, then that theme is selected by default. No further
            configuration is necessary. However, if a designer wishes
            to design a new theme, whilst retaining an older theme until
            finished, then both can exist in parallel, with one being 
            set on the live environment, and the other being set 
            on the local host. 
        </td>
    </tr>
</table>
