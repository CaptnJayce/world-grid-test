package main

import "core:mem"
import "core:os"

fp := "world_tiles.bin"

save_tiles :: proc() -> bool {
	count: u32 = 0
	for row in 0 ..< tm.height {
		for col in 0 ..< tm.width {
			tile := &tm.tiles[row][col]
			if tile.modified {
				count += 1
			}
		}
	}

	if count == 0 {
		return false
	}

	header_size := size_of(u32)
	tile_size := size_of(u32) * 3 + size_of(u8)
	total_size := header_size + int(count) * tile_size

	buffer := make([]u8, total_size)
	defer delete(buffer)

	mem.copy(&buffer[0], &count, size_of(u32))

	offset := header_size
	for row in 0 ..< tm.height {
		for col in 0 ..< tm.width {
			tile := &tm.tiles[row][col]
			if !tile.modified {
				continue
			}

			level_u32 := u32(tile.id)
			mem.copy(&buffer[offset], &level_u32, size_of(u32))
			offset += size_of(u32)

			row_u32 := u32(row)
			mem.copy(&buffer[offset], &row_u32, size_of(u32))
			offset += size_of(u32)

			col_u32 := u32(col)
			mem.copy(&buffer[offset], &col_u32, size_of(u32))
			offset += size_of(u32)

			flags := tile.flags
			mem.copy(&buffer[offset], &flags, size_of(u8))
			offset += size_of(u8)

			tile.modified = false
		}
	}

	os.write_entire_file(fp, buffer)
	return true
}

load_tiles :: proc() -> bool {
	data, ok := os.read_entire_file(fp)
	if !ok {
		return false
	}
	defer delete(data)

	if len(data) < size_of(u32) {
		return false
	}

	count: u32
	mem.copy(&count, &data[0], size_of(u32))
	offset := size_of(u32)

	tile_size := size_of(u32) * 3 + size_of(u8)
	expected_size := offset + int(count) * tile_size
	if len(data) != expected_size {
		return false
	}

	for i in 0 ..< count {
		if offset + tile_size > len(data) {
			return false
		}

		level_id: u32
		mem.copy(&level_id, &data[offset], size_of(u32))
		offset += size_of(u32)

		row: u32
		mem.copy(&row, &data[offset], size_of(u32))
		offset += size_of(u32)

		col: u32
		mem.copy(&col, &data[offset], size_of(u32))
		offset += size_of(u32)

		flags: u8
		mem.copy(&flags, &data[offset], size_of(u8))
		offset += size_of(u8)

		if int(row) < tm.height && int(col) < tm.width {
			tm.tiles[row][col].flags = transmute(bit_set[TileFlags;u8])flags
			tm.tiles[row][col].modified = true
		}
	}

	return true
}
