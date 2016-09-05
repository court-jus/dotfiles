#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urwid

palette = [
    ('banner', 'black', 'light gray', 'standout,underline', '#ffa', '#60d'),
    ('streak', 'black', 'dark red', 'standout', 'g50', '#60a'),
    ('inside', '', '', '', 'g38', '#808'),
    ('outside', '', '', '', 'g27', '#a06'),
    ('bg', 'black', 'dark blue', '', 'g7', '#d06'),
    ]

def show_or_exit(input):
    if input in ('q', 'Q'):
        raise urwid.ExitMainLoop()
    txt.set_text(('banner', repr(input)))

def do_reply(input):
    if input != 'enter':
        return
    import pdb
    pdb.set_trace()
    if fill1.body == ask:
        txt.set_text(('banner', "Nice to meet you,\n" + ask.edit_text + "."))
        fill1.body = txt
        return True
    else:
        return urwid.ExitMainLoop()

def exit_on_cr(input):
    if input == 'enter':
        raise urwid.ExitMainLoop()

def on_ask_change(edit, new_edit_text):
    assert edit is ask
    txt. set_text(('inside',  "Nice to meet you,\n" + new_edit_text + "."))

def new_question():
    return urwid.Edit(('banner', u'Namé ? '))

def new_answer(name):
    return urwid.Text(('outside', 'Hello ' + name + '\n'))

def update_on_cr(input):
    if input != 'enter':
        return
    focus_widget, position = listbox.get_focus()
    if not hasattr(focus_widget, 'edit_text'):
        return
    if not focus_widget.edit_text: # empty line
        raise urwid.ExitMainLoop()
    content[position+1:position+2] = [new_answer(focus_widget.edit_text)]
    if not content[position+2:position+3]:
        content.append(new_question())
    listbox.set_focus(position+2)
    return True

ask = urwid.Edit("What is your name?\n")
txt = urwid.Text(('banner', "Hello World"), align='center')
content = urwid.SimpleListWalker([new_question()])
listbox = urwid.ListBox(content)

mapa = urwid.AttrMap(ask, 'streak')
mapt = urwid.AttrMap(txt, 'inside')
pile = urwid.Pile([
    urwid.AttrMap(urwid.Divider(), 'outside'),
    urwid.AttrMap(urwid.Divider(), 'inside'),
    urwid.AttrMap(urwid.Divider(), 'inside'),
    urwid.AttrMap(urwid.Divider(), 'outside'),
    ])
fill = urwid.Filler(ask)
map2 = urwid.AttrMap(fill, 'bg')

urwid.connect_signal(ask, 'change', on_ask_change)
loop = urwid.MainLoop(listbox, palette, unhandled_input = update_on_cr)
loop.screen.set_terminal_properties(colors=256)
loop.run()
