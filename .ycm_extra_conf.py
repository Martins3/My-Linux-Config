import os
import ycm_core

#  可能是拯救vim中间变异驱动的方法了
# '-isystem/usr/include/',
flags = [
  '-std=c++11',
  '-Wall'
  ]

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', ]

def FlagsForFile( filename, **kwargs ):
  return {
  'flags': flags,
  'do_cache': True
  }
