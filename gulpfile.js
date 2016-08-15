const del = require("del");
const gulp = require("gulp");
const ts = require("gulp-typescript");
const cssImport = require('gulp-cssimport');
const gulpif = require('gulp-if');
const jshint = require('gulp-jshint');
const prefix = require('gulp-autoprefixer');
const browserify = require('gulp-browserify');
const sprites = require("gulp-svg-sprite");
const yargs = require('yargs');
const tsProject = ts.createProject("./lib/assets/ts/tsconfig.json");
// Minifiers
const uglify = require('gulp-uglify');
const minifyCSS = require('gulp-cssnano');
const jsdoc = require('gulp-jsdoc3');

const srcCode = ['./**/*.js', '!./node_modules/**/*.js', './package.json'];

gulp.task("transpile", () => {
    return tsProject.src()
        .pipe(ts(tsProject))
        .js.pipe(gulp.dest("dist/.static/js"));
});

gulp.task('clean', (cb) => {
    return del(['dist/.static']);
});

/**
 * Copy rasters into asset paths.
 */
gulp.task('rasters', () => {
    gulp.src('lib/assets/rasters/**/*.{png,jpg,jpeg}')
        .pipe(gulp.dest('dist/.static/images'));
});

/**
 * Copy fonts into asset paths.
 */
gulp.task('fonts', () => {
    gulp.src('lib/assets/fonts/**/*.{ttf,woff,eof,svg}')
        .pipe(gulp.dest('dist/.static/fonts'));
});

/**
 * Concatinate SVG files into a one sprite-sheet.
 */
gulp.task('sprites', () => {
    return gulp.src('lib/assets/svg/*.svg')
        .pipe(sprites({
            mode: {
                defs: true,
                sprite: 'spritesheet.svg'
            }
        }))
        .pipe(gulp.dest("dist/.static/sprites"));
});

/**
 * Compiled CSS
 */
gulp.task('styles', () => {
    return gulp.src('lib/assets/css/main.css')
        .pipe(gulpif(yargs.argv.production, minifyCSS()))
        .pipe(cssImport({}))
        .pipe(gulp.dest('dist/.static/css'));
});

/**
 * Non-TypeScript Source Files
 */
gulp.task('source', () => {
    return gulp.src(['lib/**/*', '!./**/*.ts', '!./lib/assets/**/*'])
        .pipe(gulp.dest('dist/lib'));
});

/**
 * Compile JavaScript.
 */
gulp.task('scripts', () => {
    // Single entry point to browserify
    return gulp.src(['./lib/assets/js/login.js', './lib/assets/js/register.js', './lib/assets/js/reset.js', './lib/assets/js/game.js'])
        .pipe(browserify({
            insertGlobals: false
        }))
        .pipe(gulpif(yargs.argv.production, uglify()))
        .pipe(gulp.dest('./dist/.static/js'));
});

gulp.task('lint', () => {
    return gulp.src('lib/assets/js/**/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('default'));
});

/**
 * Document the project.
 */
gulp.task('doc', function (cb) {
    const config = require('./doc/jsdoc-config.json');
    gulp.src(['README.md'].concat(srcCode), {read: false})
        .pipe(jsdoc(config, cb));
});

/**
 * Run the build of assets and javascript
 */
gulp.task('build', ['lint', 'clean'], () => {
    console.log("Building assets...");

    gulp.start('rasters');
    gulp.start('fonts');
    gulp.start('styles');
    gulp.start('sprites');
    gulp.start('scripts');
    gulp.start('transpile');
    gulp.start('source');
});

/**
 * Watch for file changes
 */
gulp.task('watch', () => {
    gulp.start('build');

    gulp.watch(['lib/assets/rasters/**/*.{png,jpg,jpeg}'], ['rasters']);
    gulp.watch(['lib/assets/fonts/**/*.{ttf,woff,eof,svg}'], ['fonts']);
    gulp.watch(['lib/assets/svg/**/*.svg'], ['sprites']);
    gulp.watch(['lib/assets/css/**/*.css'], ['styles']);
    gulp.watch(['lib/assets/js/**/*.js'], ['lint', 'scripts']);
    gulp.watch(['lib/assets/ts/**/*.ts'], ['transpile']);
    gulp.watch(['lib/**/*.json'], ['source']);
});

/**
 * Default task - run through all of the tasks
 */
gulp.task('default', function() {
    gulp.start('build');
});
