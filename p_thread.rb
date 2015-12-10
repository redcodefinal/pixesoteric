require_relative './memory_wheel'

class PThread
  #parent of the thread, should be a machine
  attr_reader :parent
  #2d array of instructions, is of type Instructions
  attr_reader :instructions
  #current instruction position
  attr_reader :position_x, :position_y
  #direction of travel
  attr_reader :direction
  #memory wheel
  attr_reader :memory_wheel
  #stages for mathematical operations
  attr_accessor :stage_1, :stage_2
  
  #is the thread paused?
  attr_reader :paused
  #how many cycles should the thread pause for
  attr_reader :paused_counter
  #has the thread ended?
  attr_reader :ended

  DIRECTIONS = [:up, :left, :down, :right]

  def initialize(parent, instructions, position_x, position_y, direction)
    @parent = parent
    @instructions = instructions
    @memory_wheel = MemoryWheel.new
    @position_x = position_x
    @position_y = position_y
    @direction = direction
    @stage_1 = 0
    @stage_2 = 0

    @paused = false
    @paused_counter = 0
    @ended = false
  end

  def clone
    thread = PThread.new(parent, instructions, position_x, position_y, direction)
    thread.instance_variable_set("@memory_wheel", memory_wheel.clone)
    thread
  end

  #runs a single instruction and moves
  def run_one_instruction
    if paused
      @paused_counter -= 1
      if @paused_counter <= 0
        unpause
      end
      return if paused
    end

    instruction = instructions.get_instruction(position_x, position_y)
    if instruction.is_a? Array
      puts "Nil instruction detected"
    end
    puts "Running #{instruction.class} @ #{position_x}, #{position_y}"
    puts "CV: #{instruction.color_value}"
    instruction.run(self, instruction.color_value)
    move 1
  end
  
  #change the direction
  def change_direction(direction)
    throw ArgumentError.new unless DIRECTIONS.include? direction
    @direction = direction
  end
  
  #turns the thread left
  def turn_left
    index = DIRECTIONS.index direction + 1
    index = 0 if index >= DIRECTIONS.length
    change_direction(DIRECTIONS[index])
  end

  #turns the thread right
  def turn_right
    index = DIRECTIONS.index direction - 1
    index = DIRECTIONS.length-1 if index < 0
    change_direction(DIRECTIONS[index])
  end

  #reverses the thread
  def reverse
    turn_left
    turn_left
  end

  #moves the instruction cursor amount units in a direction
  def move amount
    case direction
      when :up
        @position_y -= amount
      when :down
        @position_y += amount
      when :left
        @position_x -= amount
      when :right
        @position_x += amount
      else
        throw ArgumentError.new
    end
  end

  #pauses the thread for a certain amount of cycles
  def pause cycles
    @paused = true
    @paused_counter = cycles
  end

  #unpause the thread
  def unpause
    @pause = false
    @paused_counter = 0
  end

  #kill the thread
  def kill
    @ended = true
  end
end
