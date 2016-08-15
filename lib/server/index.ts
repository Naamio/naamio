/// <reference path="../../typings/index.d.ts"/>

"use strict";

import * as http from "http";
import * as url from "url";
import * as express from "express";
import * as bodyParser from "body-parser";
import * as path from "path";

let app:express.Application = express();

const cookieParser = require('cookie-parser');
const expressSession = require('express-session');
const server = require('http').createServer(app);
const passport = require('passport');
const flash = require('connect-flash');
const hbs = require('express-hbs');
const local = require('passport-local').Strategy;
const bcrypt = require('bcrypt');
const io = require('socket.io').listen(server);
const util = require('util');
const errorHandler = require('errorhandler');

const log = require('../logging');

// Set the default environment to be `development`
process.env.NODE_ENV = process.env.NODE_ENV || 'development';
process.env.PORT = process.env.PORT || 6393; //config.http.port;

if (process.env.NODE_ENV == 'development') {
    process.env.DEBUG = 'express:*';
    app.use(errorHandler());
}
else {
    // TODO: handle middleware for error handling. i.e.: app.use(errorHandler());
};

const start = () => {
    const defaultThemePath:string = path.join(__dirname, './../../../content/themes/Kumadori/');

    app.use('/resources', express.static(path.join(defaultThemePath, './.static')));
    app.use(cookieParser());
    app.engine('svg', hbs.express4({}));
    app.engine('hbs', hbs.express4({
        partialsDir: path.join(defaultThemePath, './views/parts'),
        layoutsDir: path.join(defaultThemePath, './views/layouts'),
        defaultLayout: path.join(defaultThemePath, './views/layouts/master.hbs'),
        extname: 'hbs'
    }));
    app.set('port', process.env.PORT);
    app.set('view engine', 'hbs');
    app.set('views', path.join(defaultThemePath, './views'));
    app.set('x-powered-by', 'Naamio');
    app.set('Content-Type', 'application/xhtml+xml; charset=utf-8');

    app.use(bodyParser.urlencoded({
        extended: true
    }));
    app.use(bodyParser.json());

    app.use(expressSession({
        secret: 'keyboard cat',
        resave: false,
        saveUninitialized: false
    }));

    app.use(passport.initialize());
    app.use(passport.session());
    app.use(flash());

    passport.use(new local(
        (username, password, done) => {
            // asynchronous verification, for effect...
            process.nextTick(() => {
                let validateUser = (err, user) => {
                    if (err) { return done(err); }
                    if (!user) { return done(null, false, { message: 'Unknown user: ' + username }) }

                    if (bcrypt.compareSync(password, user.password)) {
                        return done(null, user);
                    }
                    else {
                        return done(null, false, { message: 'Invalid username or password' });
                    }
                };

                // TODO: Find user by web ID and validate.
            });
        }
    ));

    passport.serializeUser((user, done) => {
        log.debug("[DEBUG][passport][serializeUser] %j", user);
        done(null, user.id);
    });

    passport.deserializeUser((id, done) => {
        // TODO: Find user from database and call callback (done).
    });

    /**
    * Standard middleware to set the correct Content Type of the documents rendered
    *
    * Use res.setHeader for JSON-specific end-points
    */
    app.use((req, res, next) => {
        res.setHeader('Content-Type', 'application/xhtml+xml; charset=utf-8');
        next();
    });

    app.post('/login',
        passport.authenticate('local', { failureRedirect: '/login', failureFlash: true }),
        function (req, res) {
            res.redirect('/topics');
        }
    );

    app.use('/', require("../routes"));

    server.listen(app.get('port'), () => {
        log.info("Naamio started.");
    });
};

const ensureAuthenticated = (req, res, next) => {
    if (req.isAuthenticated()) {
        return next();
    }

    res.redirect('/login');
};

const stop = () => {
    server.close(() => {
        log.info("Naamio stopped.");
    });

    return {
        ok: true
    };
};

export {
    start,
    stop
};