/**
 * Draws the app icons - black background, blue circle, white dot - as pngs, plus a favicon with the same picture.
 * It writes the png bytes by hand so there's no image library to install.
 *
 * Usage: node scripts/gen-icons.mjs
 */

import { writeFileSync } from 'fs';
import { deflateSync } from 'zlib';

const BACKGROUND = [0, 0, 0];
const BLUE = [10, 132, 255];
const WHITE = [255, 255, 255];
// Circle sizes as a fraction of the icon width
const OUTER_RADIUS = 0.4;
const INNER_RADIUS = 0.22;

const PNG_SIGNATURE = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);

/** The checksum that goes on the end of every png chunk */
function crc32(bytes) {
	const table = [];
	for (let i = 0; i < 256; i++) {
		let c = i;
		for (let j = 0; j < 8; j++) {
			c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
		}
		table[i] = c;
	}
	let crc = 0xffffffff;
	for (const byte of bytes) {
		crc = table[(crc ^ byte) & 0xff] ^ (crc >>> 8);
	}
	return (crc ^ 0xffffffff) >>> 0;
}

/** A png chunk is: length, type, data, crc of type + data */
function pngChunk(type, data) {
	const typeBytes = Buffer.from(type, 'ascii');
	const length = Buffer.alloc(4);
	length.writeUInt32BE(data.length);
	const crc = Buffer.alloc(4);
	crc.writeUInt32BE(crc32(Buffer.concat([typeBytes, data])));
	return Buffer.concat([length, typeBytes, data, crc]);
}

/** Builds a square rgb png, asking pixelAt(x, y, size) for the colour of each pixel */
function makePng(size, pixelAt) {
	const header = Buffer.alloc(13);
	header.writeUInt32BE(size, 0);
	header.writeUInt32BE(size, 4);
	header[8] = 8; // bits per channel
	header[9] = 2; // colour type 2 = rgb

	const rows = [];
	for (let y = 0; y < size; y++) {
		const row = Buffer.alloc(1 + size * 3);
		row[0] = 0; // no filtering on this row
		for (let x = 0; x < size; x++) {
			const [r, g, b] = pixelAt(x, y, size);
			row[1 + x * 3] = r;
			row[2 + x * 3] = g;
			row[3 + x * 3] = b;
		}
		rows.push(row);
	}

	const imageData = deflateSync(Buffer.concat(rows), { level: 9 });
	return Buffer.concat([PNG_SIGNATURE, pngChunk('IHDR', header), pngChunk('IDAT', imageData), pngChunk('IEND', Buffer.alloc(0))]);
}

/** Mixes two colours across a one pixel band either side of the edge so the circles aren't jagged */
function antialias(edge, distance, inside, outside) {
	if (distance < edge - 1) {
		return inside;
	}
	if (distance > edge + 1) {
		return outside;
	}
	const t = (distance - (edge - 1)) / 2;
	return inside.map((channel, i) => Math.round(channel * (1 - t) + outside[i] * t));
}

function iconPixel(x, y, size) {
	const centre = size / 2;
	const distance = Math.sqrt((x - centre) ** 2 + (y - centre) ** 2);
	const outer = size * OUTER_RADIUS;
	const inner = size * INNER_RADIUS;

	if (distance >= outer + 1) {
		return BACKGROUND;
	}
	const ring = antialias(outer, distance, BLUE, BACKGROUND);
	if (distance < inner + 1) {
		return antialias(inner, distance, WHITE, ring);
	}
	return ring;
}

const icon192 = makePng(192, iconPixel);
const icon512 = makePng(512, iconPixel);
const icon32 = makePng(32, iconPixel);

writeFileSync('public/icon-192.png', icon192);
writeFileSync('public/icon-512.png', icon512);

// An ico file is a small header, one directory entry per image, then the image data. Browsers are happy with a png inside
const icoHeader = Buffer.alloc(6);
icoHeader.writeUInt16LE(0, 0); // reserved
icoHeader.writeUInt16LE(1, 2); // 1 = icon
icoHeader.writeUInt16LE(1, 4); // one image

const icoEntry = Buffer.alloc(16);
icoEntry[0] = 32; // width
icoEntry[1] = 32; // height
icoEntry[2] = 0; // no palette
icoEntry[3] = 0; // reserved
icoEntry.writeUInt16LE(1, 4); // colour planes
icoEntry.writeUInt16LE(32, 6); // bits per pixel
icoEntry.writeUInt32LE(icon32.length, 8);
icoEntry.writeUInt32LE(icoHeader.length + icoEntry.length, 12); // where the image data starts

writeFileSync('public/favicon.ico', Buffer.concat([icoHeader, icoEntry, icon32]));
console.log(`Wrote icon-192.png (${icon192.length} bytes), icon-512.png (${icon512.length} bytes) and favicon.ico`);
