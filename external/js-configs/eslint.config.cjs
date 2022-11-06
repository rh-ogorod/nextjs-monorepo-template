// Hey Emacs, this is -*- coding: utf-8 -*-

/* eslint-disable @typescript-eslint/no-var-requires */

const config = require('./base/eslint.config.cjs');

module.exports = {
  ...config,
  rules: {
    ...config.rules,
    'no-console': 'off',
  },
  settings: {
    ...config.settings,
    react: {
      version: 'detect',
    },
  },
};
