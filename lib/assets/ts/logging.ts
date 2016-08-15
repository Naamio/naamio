'use strict';

const info = (content) => {
    console.log('INFO: ' + content);
};

const warn = (content) => {
    console.log('WARNING: ' + content);
};

const error = (content) => {
    console.log('ERROR: ' + content);
};

export {
    info,
    warn,
    error
}