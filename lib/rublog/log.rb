# typed: strict
module Rublog
  class Log < T::Struct
    class OffsetNotFoundError < StandardError
    end

    extend T::Sig
    prop :semaphore, Mutex
    prop :records, [Record]
    sig { params(      record: Record).returns(Integer) }

    def append(record)
      semaphore.synchronize do
        record.offset = records.size
        records << record
      end

      record.offset
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
