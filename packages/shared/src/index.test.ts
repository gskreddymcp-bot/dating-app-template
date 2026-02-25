import { describe, expect, it } from "vitest";
import { containsFlaggedKeyword } from "./index";

describe("containsFlaggedKeyword", () => {
  it("flags risky keywords", () => {
    expect(containsFlaggedKeyword("send bitcoin now")).toBe(true);
  });

  it("allows safe message", () => {
    expect(containsFlaggedKeyword("hello there")).toBe(false);
  });
});
