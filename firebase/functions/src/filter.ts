import * as badWords from "./bad_words.json";

const list: string[] = badWords.words;
const exclude: string[] = [];

export function findProfanity(content: string): string[] {
  const profaneWords = list.filter((word) => {
    const wordExp = new RegExp(`\\b${word.replace(/(\W)/g, "\\$1")}\\b`, "gi");
    return !exclude.includes(word.toLowerCase()) && wordExp.test(content);
  });

  return profaneWords;
}
