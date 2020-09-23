# SHA2 256bit fully pipelined 320 layer architecture

- simulatable and synthesizable portable VHDL code
- pipeline elements are separately optimized and contain 5 level pipeline each
- the full pipeline consists of 64 pipeline elements
- calculates 320 separate input stream's hashes parallelly
- compression pipeline input can be initialized with arbitrary intermediate hash state
- most of the shift registers have been replaced with circular buffers to decrease unnecessary bit flipping and with that power consumption
