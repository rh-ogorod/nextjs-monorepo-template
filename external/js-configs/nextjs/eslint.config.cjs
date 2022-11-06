// Hey Emacs, this is -*- coding: utf-8 -*-

const path = require('path');

const packageRoot = path.resolve(path.join(__dirname, '..'));

module.exports = {
  extends: [
    path.join(packageRoot, 'react/eslint.config.cjs'),
    'next/core-web-vitals',
  ],
};
