import js from "@eslint/js";
import globals from "globals";

export default [
  js.configs.recommended, // Active les règles recommandées par défaut
  {
    files: ["**/*.{js,mjs,cjs}"],
    languageOptions: {
      globals: {
        ...globals.node,    // ✅ Fixe l'erreur 'process' is not defined
        ...globals.browser, // Utile pour le dossier frontend
      },
      ecmaVersion: "latest",
    },
  },
  {
    files: ["**/*.js"],
    languageOptions: {
      sourceType: "commonjs", // ✅ Autorise 'require' et 'module.exports'
    },
  },
];