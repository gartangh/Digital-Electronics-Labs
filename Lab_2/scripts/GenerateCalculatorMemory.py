#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random

def memory_file_comment(memory_file, content):
    memory_file.write("# " + content + "\n")

def memory_file_reset(memory_file, reset):
    memory_file.write(str(reset) + " ")

def memory_file_buttons(memory_file, button_center, button_left, button_right):
    memory_file.write(str(button_center))
    memory_file.write(str(button_left))
    memory_file.write(str(button_right))
    memory_file.write(" ")

def memory_file_counter(memory_file, counter):
    memory_file.write("{0:04b} ".format(counter))

def memory_file_display(memory_file, character_list):
    segment_dictionary = {
            '0' : "0000",
            '1' : "0001",
            '2' : "0010",
            '3' : "0011",
            '4' : "0100",
            '5' : "0101",
            '6' : "0110",
            '7' : "0111",
            '8' : "1000",
            '9' : "1001",
            '-' : "1111"
            }

    display_mask = []
    display_data = []

    for character in character_list:
        if character in segment_dictionary:
            display_mask.append('1')
            display_data.append(segment_dictionary[character])
        else:
            display_mask.append('0')
            display_data.append("0000")

    memory_file.write("{0} {1}\n".format("".join(display_data), "".join(display_mask)))

def memory_file_writeline(memory_file, reset=1, button_center=0, button_left=0, button_right=0, counter=0, character_list=['-', '-', '-', '-']):
    memory_file_reset(memory_file, reset)
    memory_file_buttons(memory_file, button_center, button_left, button_right)
    memory_file_counter(memory_file, counter)
    memory_file_display(memory_file, character_list)

def number_to_character_list(number):
    if number < 0:
        character_list = ['', '-', '', str(-number)]
    elif number > 9:
        character_list = ['', '', str(number // 10), str(number % 10)]
    else:
        character_list = ['', '', '', str(number)]

    return character_list


def memory_file_invalid_moves(memory_file, counter=0, character_list=['-', '-', '-', '-']):
    memory_file_writeline(memory_file, 0, 0, 1, 0, counter, character_list);
    memory_file_writeline(memory_file, 0, 0, 0, 1, counter, character_list);

def memory_file_operation(memory_file, a, b, operation):
    memory_file_comment(memory_file, "{0} {1} {2} = {3}".format(
        a,
        '+' if operation == 0 else '-',
        b,
        a + b if operation == 0 else a - b))
    # Reset
    memory_file_writeline(memory_file)
    # Opstarten nieuwe berekening
    memory_file_writeline(memory_file, 0, 1, 0, 0, 0)

    if random.random() < 0.25:
        memory_file_comment(memory_file, "Testing button_left and button_right")
        memory_file_invalid_moves(memory_file, 0, 0, number_to_character_list(0))

    # Invoer operand 1
    memory_file_writeline(memory_file, 0, 0, 0, 0, a, number_to_character_list(a))

    if random.random() < 0.25:
        memory_file_comment(memory_file, "Testing button_left and button_right")
        memory_file_invalid_moves(memory_file, a, number_to_character_list(a))

    # Bevestigen operand 1
    memory_file_writeline(memory_file, 0, 1, 0, 0, a, number_to_character_list(a))

    if random.random() < 0.25:
        memory_file_comment(memory_file, "Testing button_left and button_right")
        memory_file_invalid_moves(memory_file, a, number_to_character_list(a))

    # Invoer operand 2
    memory_file_writeline(memory_file, 0, 0, 0, 0, b, number_to_character_list(b))

    if random.random() < 0.25:
        memory_file_comment(memory_file, "Testing button_left and button_right")
        memory_file_invalid_moves(memory_file, b, number_to_character_list(b))

    # Bevestigen operand 2
    memory_file_writeline(memory_file, 0, 1, 0, 0, b, number_to_character_list(b))
    # Keuze operatie
    if operation == 0:
        memory_file_writeline(memory_file, 0, 0, 0, 1, b, number_to_character_list(b))
        memory_file_writeline(memory_file, 0, 0, 0, 0, 0, number_to_character_list(a + b))
    else:
        memory_file_writeline(memory_file, 0, 0, 1, 0, b, number_to_character_list(b))
        memory_file_writeline(memory_file, 0, 0, 0, 0, 0, number_to_character_list(a - b))

def main():
    memory_file = open('testbank_calculator.mem', 'w')

    memory_file_operation(memory_file, 1, 1, 0)
    memory_file_operation(memory_file, 9, 8, 0)
    memory_file_operation(memory_file, 9, 9, 1)
    memory_file_operation(memory_file, 0, 0, 0)
    memory_file_operation(memory_file, 0, 9, 1)

    memory_file.close()

if __name__ == "__main__":
    main()

