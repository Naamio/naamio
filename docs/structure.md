# Directory Structure

`Naamio` has, within it, a text transformation engine. 
The concept behind the system is this: you give it text 
written in your favorite markup language, be that Markdown, 
Stencil, or just plain XHTML, and it churns that through a 
layout or a series of layout files. Throughout that process 
you can tweak how you want the site URLs to look, what data 
gets displayed in the layout, and more. This is all done 
through editing text files; the resulting web application 
is the final product.

A basic Naamio site usually looks something like this (with
a little inspiration from Jekyll's documentation):

    .
    ├── _config.yml
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
    ├── themes
    |   └── my-theme
    |       ├── assets
    |       |   ├── scripts   
    |       |   |   ├── js
    |       |   |   |   ├── d3.js
    |       |   |   |   └── mail.js
    |       |   |   └── ts
    |       |   |       ├── app.ts
    |       |   |       └── branding.ts
    |       |   ├── images
    |       |   |   ├── rasters
    |       |   |   └── vectors
    |       |   └── styles
    |       |       ├── css
    |       |       |   ├── base.css
    |       |       |   └── screen.css
    |       |       └── fonts
    |       ├── layouts
    |       |   ├── default.html
    |       |   └── post.html
    |       └── partials
    |           ├── footer.html
    |           └── header.html
    |
    ├── public
    └── .metadata

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
rasters, and vectors. Therefore, providing those within the theme will enable 
`Naamio` to run optimization routines on the assets dynamically based on demand.
In this way, `Naamio` differs from other site generators and hosts where optimizations
are commonly made prior to deployment, based on the designer's assumptions.

Where optimizations cannot currently be made, namely in pre-compilation 
of sources, such as LESS, SASS, and TypeScript, `Naamio` still supports 
the addition of such sources into the repository and will ensure that those
sources are treated as "raw", and are thus ignored.