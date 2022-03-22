# typed: strict
module Rublog
  class Record < T::Struct
    prop :value, String
    prop :offset, Integer
  end
end
