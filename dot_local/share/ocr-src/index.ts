#!/usr/bin/env bun

import path from 'node:path';
import { createWorker } from 'tesseract.js';
import ora from 'ora';

const imagePath = process.argv[2];

if (!imagePath) {
  console.error('Usage: bun index.ts <image_path>');
  process.exit(1);
}

const ext = path.extname(imagePath).toLowerCase();
if (!['.png', '.jpg', '.jpeg', '.bmp', '.tiff'].includes(ext)) {
  console.error('Path is not an image file (supported extensions: .png, .jpg, .jpeg, .bmp, .tiff)');
  process.exit(1);
}

const exists = await Bun.file(imagePath).exists();
if (!exists) {
  console.error('Image file does not exist');
  process.exit(1);
}

const spinner = ora({ stream: process.stderr, text: 'Initializing...' }).start();

const worker = await createWorker('eng', 1, {
  logger: (m) => {
    spinner.text = m.status || 'Processing...';
  },
});
const { data: { text } } = await worker.recognize(imagePath);
await worker.terminate();

spinner.stop();
console.log(text);
