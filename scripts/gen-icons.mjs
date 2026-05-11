import fs from 'fs'
import zlib from 'zlib'

function crc32(buf) {
  const table = []
  for (let i = 0; i < 256; i++) {
    let c = i
    for (let j = 0; j < 8; j++) c = (c & 1) ? (0xedb88320 ^ (c >>> 1)) : (c >>> 1)
    table[i] = c
  }
  let crc = 0xffffffff
  for (let i = 0; i < buf.length; i++) crc = table[(crc ^ buf[i]) & 0xff] ^ (crc >>> 8)
  return (crc ^ 0xffffffff) >>> 0
}

function makeChunk(type, data) {
  const typeBytes = Buffer.from(type, 'ascii')
  const len = Buffer.alloc(4)
  len.writeUInt32BE(data.length)
  const crcInput = Buffer.concat([typeBytes, data])
  const crcBuf = Buffer.alloc(4)
  crcBuf.writeUInt32BE(crc32(crcInput))
  return Buffer.concat([len, typeBytes, data, crcBuf])
}

function makePNG(size, pixelFn) {
  const sig = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10])
  const ihdr = Buffer.alloc(13)
  ihdr.writeUInt32BE(size, 0)
  ihdr.writeUInt32BE(size, 4)
  ihdr[8] = 8  // bit depth
  ihdr[9] = 2  // RGB color type

  const rows = []
  for (let y = 0; y < size; y++) {
    const row = Buffer.alloc(1 + size * 3)
    row[0] = 0 // filter: None
    for (let x = 0; x < size; x++) {
      const [r, g, b] = pixelFn(x, y, size)
      row[1 + x * 3] = r
      row[1 + x * 3 + 1] = g
      row[1 + x * 3 + 2] = b
    }
    rows.push(row)
  }

  const raw = Buffer.concat(rows)
  const idat = zlib.deflateSync(raw, { level: 9 })
  return Buffer.concat([sig, makeChunk('IHDR', ihdr), makeChunk('IDAT', idat), makeChunk('IEND', Buffer.alloc(0))])
}

// Black bg + blue circle with subtle inner ring
function iconPixel(x, y, size) {
  const cx = size / 2
  const cy = size / 2
  const outerR = size * 0.40
  const innerR = size * 0.22

  const bg = [0, 0, 0]
  const blue = [10, 132, 255]
  const white = [255, 255, 255]

  const dist = Math.sqrt((x - cx) ** 2 + (y - cy) ** 2)

  // Anti-alias helper
  function aa(edge, val, lo, hi) {
    if (val < edge - 1) return lo
    if (val > edge + 1) return hi
    const t = (val - (edge - 1)) / 2
    return lo.map((c, i) => Math.round(c * (1 - t) + hi[i] * t))
  }

  // Outer blue circle
  if (dist < outerR + 1) {
    const outerColor = aa(outerR, dist, blue, bg)
    // Inner white circle (accent)
    if (dist < innerR + 1) {
      return aa(innerR, dist, white, outerColor)
    }
    return outerColor
  }
  return bg
}

const png192 = makePNG(192, iconPixel)
const png512 = makePNG(512, iconPixel)
const png32 = makePNG(32, iconPixel)

fs.writeFileSync('public/icon-192.png', png192)
fs.writeFileSync('public/icon-512.png', png512)
console.log(`icon-192.png: ${png192.length} bytes`)
console.log(`icon-512.png: ${png512.length} bytes`)

// favicon.ico with embedded 32x32 PNG
const icoHeader = Buffer.alloc(6)
icoHeader.writeUInt16LE(0, 0)  // reserved
icoHeader.writeUInt16LE(1, 2)  // type: icon
icoHeader.writeUInt16LE(1, 4)  // count: 1

const icoEntry = Buffer.alloc(16)
icoEntry[0] = 32   // width
icoEntry[1] = 32   // height
icoEntry[2] = 0    // palette count
icoEntry[3] = 0    // reserved
icoEntry.writeUInt16LE(1, 4)              // color planes
icoEntry.writeUInt16LE(32, 6)            // bits per pixel
icoEntry.writeUInt32LE(png32.length, 8)  // image data size
icoEntry.writeUInt32LE(22, 12)           // offset: 6 (header) + 16 (entry)

const ico = Buffer.concat([icoHeader, icoEntry, png32])
fs.writeFileSync('public/favicon.ico', ico)
console.log(`favicon.ico: ${ico.length} bytes`)
