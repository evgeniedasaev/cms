##############################################################################
#
##############################################################################

@CLASS
transliter

@auto[]
$eng[^table::create{from	to
А	A
а	a
Б	B
б	b
В	V
в	v
Г	G
г	g
Д	D
д	d
Е	E
е	e
Ё	E
ё	e
Ж	Zh
ж	zh
З	Z
з	z
И	I
и	i
Й	J
й	j
К	K
к	k
Л	L
л	l
М	M
м	m
Н	N
н	n
О	O
о	o
П	P
п	p
Р	R
р	r
С	S
с	s
Т	T
т	t
У	U
у	u
Ф	F
ф	f
Х	H
х	h
Ц	Ts
ц	ts
Ч	Ch
ч	ch
Ш	Sh
ш	sh
Щ	Shch
щ	shch
Ъ	'
ъ	'
Ы	Y
ы	y
Ь	'
ь	'
Э	Ye
э	ye
Ю	Yu
ю	yu
Я	Ya
я	ya
}]
# Таблица ГОСТ 16876-71
$gost[^table::create{from	to
А	A
а	a
Б	B
б	b
В	V
в	v
Г	G
г	g
Д	D
д	d
Е	E
е	e
Ё	E
ё	e
Ж	Zh
ж	zh
З	Z
з	z
И	I
и	i
Й	Jj
й	jj
К	K
к	k
Л	L
л	l
М	M
м	m
Н	N
н	n
О	O
о	o
П	P
п	p
Р	R
р	r
С	S
с	s
Т	T
т	t
У	U
у	u
Ф	F
ф	f
Х	Kh
х	kh
Ц	С
ц	с
Ч	Ch
ч	ch
Ш	Sh
ш	sh
Щ	Shh
щ	shh
Ъ	"
ъ	"
Ы	Y
ы	y
Ь	'
ь	'
Э	Eh
э	eh
Ю	Ju
ю	ju
Я	Ja
я	ja
}]
$eng_low[^table::create{from	to
А	a
а	a
Б	b
б	b
В	v
в	v
Г	g
г	g
Д	d
д	d
Е	e
е	e
Ё	e
ё	e
Ж	zh
ж	zh
З	z
з	z
И	i
и	i
Й	j
й	j
К	K
к	k
Л	L
л	l
М	m
м	m
Н	n
н	n
О	o
о	o
П	p
п	p
Р	r
р	r
С	s
с	s
Т	t
т	t
У	u
у	u
Ф	f
ф	f
Х	h
х	h
Ц	ts
ц	ts
Ч	ch
ч	ch
Ш	sh
ш	sh
Щ	shch
щ	shch
Ъ
ъ
Ы	y
ы	y
Ь
ь
Э	ye
э	ye
Ю	yu
ю	yu
Я	ya
я	ya
}]



##############################################################################
@format[text;table;string][type]
$type[^switch[$table]{
	^case[GOST]{$gost}
	^case[ENG_LOW]{$eng_low}
	^case[ENG;DEFAULT]{$eng}
}]
$result[^text.replace[$type]]
^if(def $string){
	$result[^result.match[^if($string eq "s"){'}{\s}][g]{$string}]
}
#end of @format
