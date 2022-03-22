require_relative("./record")

# typed: strict
module Rublog
  class Log < T::Struct
    class OffsetNotFoundError < StandardError
    end

    extend T::Sig
    prop :semaphore, Mutex,     default: Mutex.new
    prop :records, T::Array[Record],     default: []
    sig { params(      value: String).returns(Integer) }

    def append(value)
      offset = 0

      semaphore.synchronize do
        record = Record.new(        value: value,         offset: records.size)
        records << record
        offset = record.offset
      end

      offset
    end

    sig { params(      offset: Integer).returns(Record) }

    def read(offset)
      semaphore.synchronize do
        raise OffsetNotFoundError unless (0...records.length).include?(offset)
        records[offset]
      end
    end
  end
end
