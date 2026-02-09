CC = gcc
CFLAGS = -Wall -O2 -std=c23 -Iinclude
LIB_NAME = pretticy
SRC_DIR = src
OBJ_DIR = build
INC_DIR = include

STATIC_LIB = $(OBJ_DIR)/lib$(LIB_NAME).a
SHARED_LIB = $(OBJ_DIR)/lib$(LIB_NAME).so

TEST_SRC = tests/test.c
TEST_BIN = build/test_runner


all: $(STATIC_LIB) $(SHARED_LIB)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(STATIC_LIB): $(OBJ_DIR)/$(LIB_NAME).o
	ar rcs $@ $^

$(SHARED_LIB): $(OBJ_DIR)/$(LIB_NAME)_shared.o
	$(CC) -shared -o $@ $^

$(OBJ_DIR)/$(LIB_NAME).o: $(SRC_DIR)/$(LIB_NAME).c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/$(LIB_NAME)_shared.o: $(SRC_DIR)/$(LIB_NAME).c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

test: $(STATIC_LIB)
	$(CC) $(CFLAGS) $(TEST_SRC) $(STATIC_LIB) -o $(TEST_BIN)
	./$(TEST_BIN)
clean:
	rm -rf $(OBJ_DIR)
