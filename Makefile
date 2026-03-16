APP = build/protector
SRC = src/protector.asm
OBJ = build/protector.o

all: pre_build $(APP)

pre_build:
	@mkdir -p build

$(APP): $(OBJ)
	ld -s -o $(APP) $(OBJ)

$(OBJ): $(SRC)
	nasm -f elf64 -o $(OBJ) $(SRC)

clean:
	rm -rf build/