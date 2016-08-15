/// <reference path="../../typings/index.d.ts"/>

'use strict';

const winston = require('winston');

var logger;

const debug = (content) => {
  logger.debug(content);
};

const info = (content) => {
  logger.info(content);
};

const warn = (content) => {
  logger.warn(content);
};

const error = (content) => {
  logger.error(content);
};

const init = () => {

  let quipLevels = {
    levels: {
      error: 0,
      warn: 1,
      info: 2,
      verbose: 3,
      debug: 4,
      silly: 5
    },
    colors: {
      error: 'red',
      warn: 'yellow',
      info: 'green',
      verbose: 'blue',
      debug: 'purple',
      silly: 'pink'
    }
  };

  let OJTransports = [
    new (winston.transports.Console) ({ 
      colorize: true,
      level: (process.env.NODE_ENV == 'development') ? 'debug' : 'info',
      handleExceptions: true,
      json: false
    }),
    new (winston.transports.File) ({ 
      colorize: false,
      filename: 'log/quip.log', 
      handleExceptions: true,
      json: true,
      level: 'warn', 
      maxsize: 5242880,
      maxFiles: 5
    })
  ];

  logger = new (winston.Logger) ({ 
    levels: quipLevels.levels, 
    transports: OJTransports 
  });

  logger.debug("Initiated logging.");
};

init();

export {
  debug as debug,
  info as info,
  warn as warn,
  error as error
};
