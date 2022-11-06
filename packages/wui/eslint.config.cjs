// Hey Emacs, this is -*- coding: utf-8 -*-

const config = require('@rh-ogorod/js-configs/nextjs/eslint.config.cjs');
// const config = require('../../external/js-configs/nextjs/eslint.config.cjs');

module.exports = {
  ...config,
  rules: {
    ...config.rules,
    'no-console': 'off',
  },
  overrides: [
    {
      "files": ["*.js", "*.cjs", "*.mjs", "*.jsx", "*.ts", "*.tsx"],
    },
  ],
};
