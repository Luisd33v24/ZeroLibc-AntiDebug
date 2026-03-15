APP = protector
SRC = protector.asm
OBJ = protector.o

all: $(APP)

$(APP): $(OBJ)
	ld -s -o $(APP) $(OBJ)

$(OBJ): $(SRC)
	nasm -f elf64 -o $(OBJ) $(SRC)

clean:
	rm -f $(OBJ) $(APP)