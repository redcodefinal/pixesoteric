require_relative '../../instruction'
require_relative '../../colors'

class GreaterThanCV < Instruction
  class << self
    def pattern
      [
          [Colors::BLACK, Colors::BLACK, Colors::WHITE],
          [Colors::BLACK, Colors::WHITE, Colors::WHITE],
          [Colors::BLACK, Colors::WHITE, Colors::WHITE],
      ]
    end

    def run(thread, color_value)
      if thread.memory_wheel.pull.to_i > color_value.to_i
        thread.memory_wheel.push 0
      else
        thread.memory_wheel.push 1
      end
    end
  end
end

class S1GreaterThanS2 < Instruction
  class << self
    def pattern
      [
          [Colors::BLACK, Colors::WHITE, Colors::WHITE],
          [Colors::BLACK, Colors::WHITE, Colors::WHITE],
          [Colors::BLACK, Colors::BLACK, Colors::WHITE],
      ]
    end

    def run(thread, color_value)
      if thread.memory_wheel.stage_1 > thread.memory_wheel.stage_2
        thread.memory_wheel.push 1
      else
        thread.memory_wheel.push 0
      end
    end
  end
end
