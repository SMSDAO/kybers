// eslint.config.js
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import react from "eslint-plugin-react";
import jsxA11y from "eslint-plugin-jsx-a11y";

export default [
  // Base recommended rules
  js.configs.recommended,

  // TypeScript recommended rules
  ...tseslint.configs.recommended,

  {
    files: ["**/*.js", "**/*.ts", "**/*.tsx"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      parser: tseslint.parser,
    },
    plugins: {
      react,
      "jsx-a11y": jsxA11y,
    },
    rules: {
      // Example custom rules
      "no-unused-vars": "warn",
      "no-console": "off",
      "react/jsx-uses-react": "off", // not needed in React 17+
      "react/react-in-jsx-scope": "off", // not needed in React 17+
    },
  },
];
