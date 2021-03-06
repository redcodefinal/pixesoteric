require_relative './color'

# Wheel type memory structure used by PThread.
class MemoryWheel
  # memory array for the wheel
  attr_reader :memory
  # current position in memory
  attr_reader :memory_position

  def initialize
    @memory = {}
    @memory_position = 0

    # set the first memory space
    push 0
  end

  def clone
    memory_wheel = MemoryWheel.new
    memory_wheel.instance_variable_set('@memory', memory.clone)
    memory_wheel.instance_variable_set('@memory_position', memory_position)
    memory_wheel
  end

  # moves the memory position to the right
  def move_right
    @memory_position += 1
    @memory_position = 0 if @memory_position > 0xfffffe
  end

  # moves the memory position to the left
  def move_left
    @memory_position -= 1
    @memory_position = 0xfffffe if @memory_position < 0
  end

  # returns the value at the current memory location
  def pull
    @memory[memory_position] || Color.new(0)
  end

  # pushes a value into the current memory location.
  # Note: Rolls bytes over if too large / negative
  # -1 = 0xffffff, 0x1000000 = 0x0
  def push(x)
    @memory[memory_position] = Color.new(x.to_i)
  end

  # jumps to a absolute memory position
  def jump(x)
    @memory_position = x
  end

  def to_s
    dump = memory.inject([]) do |a, p|
      if p.first == memory_position
        a << "<{#{p.first.to_s 16}=#{p.last.to_i}}>"
      else
        a << "#{p.first.to_s 16}=#{p.last.to_i}"

      end
    end

    dump.join(' ')
  end
end
