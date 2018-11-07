import os
import ycm_core

flags = [
  '-std=c++11',
  '-Wall'
]

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', ]

def FlagsForFile(filename, **kwargs):
    return {
    'flags': flags,
    'do_cache': True
}
