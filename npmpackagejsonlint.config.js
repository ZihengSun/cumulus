'use strict';

module.exports = {
  rules: {
    // Required properties
    // 'require-bugs': 'error',
    'require-description': 'error',
    // 'require-engines': 'error',
    // 'require-homepage': 'error',
    // 'require-keywords': 'error',
    'require-license': 'error',
    'require-name': 'error',
    // 'require-private': 'error',
    // 'require-repository': 'error',
    // 'require-repository-directory': 'error',
    // 'require-scripts': 'error',
    'require-version': 'error',

    // Make sure we're using the right types
    'bin-type': 'error',
    'bundledDependencies-type': 'error',
    'config-type': 'error',
    'cpu-type': 'error',
    'dependencies-type': 'error',
    'description-type': 'error',
    'devDependencies-type': 'error',
    'directories-type': 'error',
    'engines-type': 'error',
    'files-type': 'error',
    'homepage-type': 'error',
    'keywords-type': 'error',
    'license-type': 'error',
    'main-type': 'error',
    'man-type': 'error',
    'name-type': 'error',
    'optionalDependencies-type': 'error',
    'os-type': 'error',
    'peerDependencies-type': 'error',
    'preferGlobal-type': 'error',
    'private-type': 'error',
    'repository-type': 'error',
    'scripts-type': 'error',
    'version-type': 'error',

    // Make sure we're using the correct values
    // 'valid-values-engines': ['error', [{ node: '>=12.18.0' }]],
    'valid-values-license': ['error', ['Apache-2.0']],
    'valid-values-name-scope': ['error', ['@cumulus']],

    // Dependency rules
    // 'no-repeated-dependencies': 'error',
    // 'prefer-alphabetical-dependencies': 'error',
    // 'prefer-alphabetical-devDependencies': 'error',

    // // Scripts rules
    // 'prefer-alphabetical-scripts': 'error',
    // 'prefer-scripts': ['error', ['test']],

    // Format rules
    'name-format': 'error',
    'version-format': 'error',

    // Property order
    'prefer-property-order': [
      'error',
      [
        'name',
        'version',
        'description',
        //     'keywords',
        //     'homepage',
        //     'bugs',
        'license',
        //     'author',
        // //     'contributors',
        //     'files',
        //     'main',
        //     'module',
        //     'jsnext:main',
        //     'types',
        //     'typings',
        //     'style',
        //     'example',
        //     'examplestyle',
        //     'assets',
        //     'bin',
        //     'man',
        //     'directories',
        //     'repository',
        //     'scripts',
        //     'config',
        //     'pre-commit',
        // 'ava',
        // 'nyc',
        //     'browser',
        //     'browserify',
        //     'babel',
        //     'eslintConfig',
        //     'stylelint',
        //     'npmpackagejsonlint',
        //     'dependencies',
        //     'devDependencies',
        //     'peerDependencies',
        //     'bundledDependencies',
        //     'bundleDependencies',
        //     'optionalDependencies',
        //     'engines',
        //     'engineStrict',
        //     'os',
        //     'cpu',
        //     'preferGlobal',
        //     'private',
        //     'publishConfig'
      ],
    ],
    'no-duplicate-properties': 'error',
  },
};
