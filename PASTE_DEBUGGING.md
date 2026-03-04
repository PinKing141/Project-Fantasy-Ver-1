# Fixing "it keeps pasting" bugs

If your app keeps pasting text repeatedly, the most common causes are:

1. A `keydown` handler that runs while a key is held (`event.repeat === true`).
2. Duplicate event listeners being registered on every re-render/restart.
3. Handling both `keydown` and `paste` for the same shortcut without guards.
4. Using synthetic "insert text" logic in addition to browser paste behavior.

## Quick safe pattern (JavaScript)

```js
let isListenerAttached = false;

export function attachEditorShortcuts(editorEl, onPasteText) {
  if (isListenerAttached) return;
  isListenerAttached = true;

  editorEl.addEventListener('keydown', async (event) => {
    // Ignore auto-repeat while key is held down.
    if (event.repeat) return;

    const isPasteShortcut =
      (event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'v';

    if (!isPasteShortcut) return;

    event.preventDefault();

    // Prefer Clipboard API when available.
    const text = await navigator.clipboard.readText();
    if (!text) return;

    onPasteText(text);
  });

  editorEl.addEventListener('paste', (event) => {
    // Guard to avoid duplicate insertion from keydown + paste.
    event.preventDefault();

    const text = event.clipboardData?.getData('text/plain') ?? '';
    if (!text) return;

    onPasteText(text);
  });
}
```

## If you're using React

- Ensure shortcut listeners are attached once in `useEffect(..., [])`.
- Clean up listeners in the `return () => ...` cleanup function.
- Never define listener setup inside render logic.

## Debug checklist

- Log each listener registration; confirm it happens once.
- Log `event.repeat` in `keydown`; repeated `true` means key-hold spam.
- Log before insertion to see whether `keydown` and `paste` both fire.
- Temporarily disable one handler (`keydown` or `paste`) to isolate duplicates.

## Typical root fix

Most projects are fixed by combining:

- listener de-duplication,
- `event.repeat` guard, and
- a single insertion path.
