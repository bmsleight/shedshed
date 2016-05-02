#!/usr/bin/python
# -*- coding: utf-8 -*-
#
#   shed - Openscad solidpython Shed plans. 
#   Copyright (C) Brendan M. Sleight, et al. <bms.stl#barwap.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

from solid import *
from solid.utils import *
import os, sys, re, argparse

timber_width=47
timber_thickness=47
mdf_thickness=18
ply_thickness=18

feet = 305.0

shed_inner_width = feet*7.0


# Using the corner where the chimeny start to jut out at 0,0
garden_width = 6000
genden_length = 2500



#To Have Marks 
MARK = False
#MARK = True

class Parts(object):
    def __init__(self):
        self.total_parts = 0
        self.name = "Default Name"
    def mark_part(self, comments=""):
        # A nice fancy function would be better....
        marks = union()
        self.total_parts += 1
        print self.name + ", " + comments + ", Marked :", bin(self.total_parts)
        for power in range(0,7):
            m = up(power*2)(left(0.5)(back(0.5)(cube([1,1,1]) ) ))
            m = m + forward(power*2)(up(-0.5)(left(0.5)(cube([1,1,1]) ) ))
            m = m + right(power*2)(forward(-0.5)(up(-0.5)(cube([1,1,1]) ) ))
            if self.total_parts & int((math.pow(2,power))):
                m = color(Black)(m)
            else:
                m = color(White)(m)
            marks = marks + m
        return marks

def wood(timber_width, timber_thickness, timber_length, direction=1):
    # directions 1, 2, 3 
    #  is 1 along, (y-axis) 
    #  is 2 up, (z-axis)
    #  is 3 out, (x-axis)
 
    if direction == 1:
        timber = color(Pine)(cube([timber_width, timber_length, timber_thickness]))
    elif direction == 2:
        timber = color(Pine)(cube([timber_width, timber_thickness, timber_length]))
    elif direction == 3:
        timber = color(Pine)(cube([timber_length, timber_width, timber_thickness]))

    elif direction == 4: # as 1
        timber = color(Pine)(cube([timber_thickness, timber_length, timber_width]))
    elif direction == 5:
        timber = color(Pine)(cube([timber_thickness, timber_width, timber_length]))
    elif direction == 6:
        timber = color(Pine)(cube([timber_length, timber_thickness, timber_width]))

    if MARK:
        comments = "Length: " + str(timber_length) + ", width: " + str(timber_width) + ", thickness:" + str(timber_thickness)
        timber = timber + parts.mark_part(comments)
    return timber

def timber(timber_length, direction=1):
#    timber_width=37
#    timber_thickness=60
    return wood(timber_width, timber_thickness, timber_length, direction)

def mdf_sheet(timber_length, timber_width, direction=1, timber_thickness=mdf_thickness):
    return wood(timber_width, timber_thickness, timber_length, direction)

def timber_angle_cut(timber_length, angle, direction=1):
    t = wood(timber_width, timber_thickness, timber_length, direction)
#    c = cube([timber_thickness, timber_thickness, timber_thickness])
    c = cube([99, 99, 99])

    if direction == 1:
        c = rotate([0, 0, angle])(c)
        c = translate([0,timber_length, 0])(c)
    elif direction == 2:
        c = rotate([0, angle, 0])(c)
        c = translate([0,0,timber_length])(c)
    elif direction == 3:
        c = rotate([0, 0, angle])(c)
        c = translate([timber_length, 0, 0])(c)
    elif direction == 4: # as 1
        c = rotate([angle, 0, 0])(c)
        c = translate([0, timber_length, 0])(c)
    elif direction == 5:
        c = rotate([angle, 0, 0])(c)
        c = translate([0,0,timber_length])(c)
    elif direction == 6:
        c = rotate([0, angle, 0])(c)
        c = translate([timber_length, 0, 0])(c)
    return t - c
 
def timber_square(length=1000, width=1000, direction=1, join="thick"):
    #   
    #   144442
    #   1    2
    #   1    2
    #   1    2
    #   133332
    #  

    if direction == 1 and join=="thick":
        d1 = 1
        d2 = 3
    if direction == 2 and join=="thick":
        d1 = 2
        d2 = 6
    if direction == 3 and join=="thick":
        d1 = 2
        d2 = 1
    if direction == 4 and join=="thick":
        d1 = 5
        d2 = 3

    if direction == 1 or direction == 2:
        long_strut = timber(length, d1)
        long_strut2 = timber(length,d1)
        short_strut = timber(width-(2*timber_width), d2)
        short_strut2 = timber(width-(2*timber_width), d2)
    if direction == 3 or direction == 4:
        long_strut = timber(length, d1)
        long_strut2 = timber(length, d1)
        short_strut = timber(width-(2*timber_thickness), d2)
        short_strut2 = timber(width-(2*timber_thickness), d2)

    if direction == 1 or direction == 2:
        strut1 = long_strut
        strut2 = right(width-timber_width)(long_strut2)
        strut3 = right(timber_width)(short_strut)
    if direction == 3:
        strut1 = long_strut
        strut2 = forward(width-timber_thickness)(long_strut2)
        strut3 = forward(timber_thickness)(short_strut)
    if direction == 4:
        strut1 = long_strut
        strut2 = right(width-timber_thickness)(long_strut2)
        strut3 = right(timber_thickness)(short_strut)
    if direction == 1:
        strut4 = forward(length-timber_width)(right(timber_width)(short_strut2))
    if direction == 2:
        strut4 = up(length-timber_width)(right(timber_width)(short_strut2))
    if direction == 3:
        strut4 = up(length-timber_thickness)(forward(timber_thickness)(short_strut2))
    if direction == 4:
        strut4 = up(length-timber_thickness)(right(timber_thickness)(short_strut2))

    return strut1 + strut2 + strut3 + strut4



def walls():
    # floor (not technically a wall)
    wall = back(100 + genden_width)(cube([100, genden_length,100]))
    walls = color(Transparent)(walls)
    return walls


def front_panels():
    parts.name = "Front Panels"
    panel = mdf_sheet(feet*8, feet*4, direction=2)
    panel_quarter = mdf_sheet(feet*2, feet*4, direction=2)
    panel_quarter_reverse = mdf_sheet(feet*4, feet*2, direction=2)
    # First penls extreme left front
    panels = panel + right(feet*4.0*1)(panel) + right(feet*4.0*2)(panel) 
    panels = panels + up(feet*6.0)(right(feet*4.0*3.0)(panel_quarter))
    panels = panels + right(feet*4.0*4.0)(panel_quarter_reverse) + up(feet*4.0)(right(feet*4.0*4.0)(panel_quarter_reverse))

    parts.name = "Door"
    door = right(feet*4.0*3.0)(rotate([0,0,-15])(mdf_sheet(feet*6, feet*4, direction=2)))
    panels = panels + door
    return panels


def back_panels():
    parts.name = "Back Panels - 3 quarters"
    panel = mdf_sheet(feet*4, feet*8, direction=2)
    panel_quarter = mdf_sheet(feet*2, feet*4, direction=2)
    panel_quarter_reverse = mdf_sheet(feet*4, feet*2, direction=2)
    panel_eighth = mdf_sheet(feet*2, feet*2, direction=2)
    panels = forward(shed_inner_width)(panel)
    panels = panels + right(feet*8.0)(forward(shed_inner_width)(panel))
    panels = panels + up(feet*4.0)(forward(shed_inner_width)(panel_quarter))
    panels = panels + right(feet*4.0)(up(feet*4.0)(forward(shed_inner_width)(panel_quarter)))
    panels = panels + right(feet*8.0)(up(feet*4.0)(forward(shed_inner_width)(panel_quarter)))
    panels = panels + right(feet*12.0)(up(feet*4.0)(forward(shed_inner_width)(panel_quarter)))
    panels = panels + right(feet*16.0)(up(feet*0.0)(forward(shed_inner_width)(panel_quarter_reverse)))
    panels = panels + right(feet*16.0)(up(feet*4.0)(forward(shed_inner_width)(panel_eighth)))

    return panels


if __name__ == '__main__':    

    parser = argparse.ArgumentParser()
    parser.add_argument('-f', action='store', dest='fn',
                    default="60", help='openscad $fn=')
    parser.add_argument('-s', action='store', dest='openscad',
                    help='Openscad file name')
    parser.add_argument('-w', action='store_true', default=False,
                    dest='walls',
                    help='Include the walls')
    parser.add_argument('--version', action='version', version='%(prog)s 1.0')
    options = parser.parse_args()


    parts = Parts()
    a = union()

    a = a + front_panels() + back_panels()

    if options.walls:
        a = a + walls()

    fn = '$fn=' + options.fn + ';'
    scad_render_to_file( a, options.openscad, include_orig_code=True, file_header=fn)


'''
}

module video()
{
    if ($t < (1/8))
        {
        rotate([0, 0, $t*360*8]) shift_static();
        }
    if (($t > (1/8)) && ($t < (2/8)) )
        {
        rotate([0, $t*360*8, 0]) shift_static();
        }
    if (($t > (2/8)) && ($t < (3/8)) )
        {
        rotate([$t*360*8, 0, 0]) shift_static();
        }

    if (($t > (3/8)) && ($t < (4/8)) )
        {
        rotate([0, 0, ($t*360*8/2)+180]) shift_static();
        }

    if (($t > (4/8)) && ($t < (5/8)) )
        {
        rotate([0, $t*360*8, 180]) shift_static();
        }
    if (($t > (5/8)) && ($t < (6/8)) )
        {
        rotate([$t*360*8, 0, 180]) shift_static();
        }
    if (($t > (6/8)) && ($t < (7/8)) )
        {
        rotate([0, 0, ($t*360*8/2)+180]) shift_static();
        }

    if (($t > (7/8)) && ($t < (8/8)) )
        {
        shift_static();
        }

}

video();
'''

