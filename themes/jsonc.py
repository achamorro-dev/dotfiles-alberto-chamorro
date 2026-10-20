"""Small JSONC updater that preserves unrelated preferences and comments."""

import json
import re


def tokens(text):
    pattern = r'"(?:[^"\\]|\\.)*"|//[^\n]*|/\*[\s\S]*?\*/|\s+|[^\s]'
    return [(m.group(), m.start(), m.end()) for m in re.finditer(pattern, text)
            if not m.group().isspace() and not m.group().startswith(("//", "/*"))]


def load_jsonc(text):
    parts = tokens(text)
    return json.loads("".join(t[0] for i, t in enumerate(parts)
                              if not (t[0] == "," and i + 1 < len(parts)
                                      and parts[i + 1][0] in ("}", "]"))))


def update_jsonc(text, updates):
    data = load_jsonc(text)
    if not isinstance(data, dict):
        raise ValueError("Expected a JSON object")
    for key, value in updates.items():
        if key in data and data[key] == value:
            continue
        ts = tokens(text)
        depth, spans = 0, []
        for i, (token, start, end) in enumerate(ts):
            if depth == 1 and token.startswith('"') and ts[i + 1][0] == ":":
                name = json.loads(token)
                j, nested = i + 2, 0
                while j < len(ts):
                    current = ts[j][0]
                    if nested == 0 and current in (",", "}"):
                        break
                    nested += current in ("{", "[")
                    nested -= current in ("}", "]")
                    j += 1
                if name == key:
                    spans.append((ts[i + 2][1], ts[j - 1][2]))
            depth += token in ("{", "[")
            depth -= token in ("}", "]")
        if len(spans) > 1:
            raise ValueError(f"Duplicate setting: {key}")
        encoded = json.dumps(value, ensure_ascii=False)
        indent_match = re.search(r'(?m)^([ \t]+)"', text)
        indent = indent_match.group(1) if indent_match else "  "
        if spans:
            start, end = spans[0]
            if "\n" in text[start:end]:
                line = text[text.rfind("\n", 0, start) + 1:start]
                leading = re.match(r"[ \t]*", line).group()
                encoded = json.dumps(value, ensure_ascii=False, indent=indent).replace("\n", "\n" + leading)
            text = text[:start] + encoded + text[end:]
        else:
            close = ts[-1][1]
            comma = "," if len(ts) > 2 and ts[-2][0] != "," else ""
            last = ts[-2][2] if len(ts) > 2 else ts[0][2]
            prefix = text[:last] + comma + text[last:close]
            text = (prefix + ("" if prefix.endswith("\n") else "\n")
                    + f'{indent}{json.dumps(key)}: {encoded}\n' + text[close:])
        data[key] = value
    load_jsonc(text)
    return text
