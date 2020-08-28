; Return a * c.
SimpleMultiply::
	and a
	ret z

	push bc
	ld b, a
	xor a
.loop
	add c
	dec b
	jr nz, .loop
	pop bc
	ret

; Divide a by c. Return quotient b and remainder a.
SimpleDivide::
	ld b, 0
.loop
	inc b
	sub c
	jr nc, .loop
	dec b
	add c
	ret