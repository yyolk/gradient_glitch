#!/usr/bin/env ruby

require 'rubygems'
require 'aviglitch'
  
a = AviGlitch.open ARGV[0]       # take input from STDIN
d = []
a.frames.each_with_index do |f, i|
  d.push(i) if f.is_deltaframe?  # Collecting non-keyframes indices.
end
q = a.frames[0, 5]                  # Keep first key frame.
20.times do
  x = a.frames[d[rand(d.size)], rand(5)]  # Select a certain non-keyframe.
  y = a.frames[d[rand(d.size)], rand(5)]

  q.concat(x * (rand(10)+rand(20)))            # Repeat the frame n times and concatenate with q.
  q.concat(y * rand(19))

  print "."
end
o = AviGlitch.open q                # New AviGlitch instance using the frames.
o.output ARGV[1]
