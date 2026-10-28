# Wirnikowa Maszyna Szyfrująca Model 42

Zadaniem w projekcie jest zaimplementowanie w asemblerze x86-64 (NASM) symulatora 42-znakowej maszyny szyfrującej, inspirowanej działaniem Enigmy. Maszyna wykorzystuje dwa obracające się wirniki (L i R) oraz nieruchomy wirnik odwracający (T).

## Opis plików

- **`machine_42_function.asm`** – podprogram implementujący główną funkcję szyfrującą (zgodną z ABI System V AMD64). Transformuje ona bufor tekstu na podstawie podanych permutacji wirników i klucza.
- **`machine_42.asm`** – główny program (CLI). Odpowiada za walidację parametrów startowych, wczytywanie tekstu ze standardowego wejścia, wywołanie funkcji szyfrującej oraz wypisanie wyniku na standardowe wyjście.

## Kompilacja i budowanie

```bash
nasm -f elf64 -w+all -w+error -w-unknown-warning -w-reloc-rel -o machine_42_function.o machine_42_function.asm
nasm -f elf64 -w+all -w+error -w-unknown-warning -w-reloc-rel -o machine_42.o machine_42.asm
ld -pie -I /lib64/ld-linux-x86-64.so.2 --fatal-warnings -o machine_42 machine_42_function.o machine_42.o
```

## Wywołanie programu

Program przyjmuje cztery argumenty (permutacja L, R, T oraz 2-znakowy klucz) i czyta tekst ze standardowego wejścia:

```bash
./machine_42 "HSC=..." "LJ?;..." "R6>5..." "SO" < tekst_jawny.txt
```
