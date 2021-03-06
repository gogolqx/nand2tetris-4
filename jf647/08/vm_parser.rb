require 'rltk'

module VM

    class Parser < RLTK::Parser

        class Environment < Environment
            attr_accessor :ns
        end

        p(:vmline) do
            c('op COMMENT?')                { |o,_| o }
            c('COMMENT')                    { |_| Comment.new }
            c('')                           { Blank.new }
        end

        p(:op) do
            c('PUSH segname NUMBER')        { |_,seg,val| PushCommand.new(seg, val, @ns) }
            c('POP segname NUMBER')         { |_,seg,val| PopCommand.new(seg, val, @ns) }
            c('LABEL SYMBOL')               { |_,s| LabelCommand.new(s) }
            c('IFGOTO SYMBOL')              { |_,s| IfGotoCommand.new(s) }
            c('GOTO SYMBOL')                { |_,s| GotoCommand.new(s) }
            c('FUNCTION SYMBOL NUMBER')     { |_,s,n| FunctionCommand.new(s,n) }
            c('CALL SYMBOL NUMBER')         { |_,s,n| CallCommand.new(s,n) }
            c('RETURN')                     { |_| ReturnCommand.new }
            c('ADD')                        { |_| AddCommand.new }
            c('SUB')                        { |_| SubCommand.new }
            c('EQ')                         { |_| EqualsCommand.new }
            c('LT')                         { |_| LessThanCommand.new }
            c('GT')                         { |_| GreaterThanCommand.new }
            c('NEG')                        { |_| NegateCommand.new }
            c('AND')                        { |_| AndCommand.new }
            c('OR')                         { |_| OrCommand.new }
            c('NOT')                        { |_| NotCommand.new }
        end

        p(:segname) do
            c('SEG_ARGUMENT')               { |_| :argument }
            c('SEG_LOCAL')                  { |_| :local }
            c('SEG_STATIC')                 { |_| :static }
            c('SEG_CONSTANT')               { |_| :constant }
            c('SEG_LOCAL')                  { |_| :local }
            c('SEG_THIS')                   { |_| :this }
            c('SEG_THAT')                   { |_| :that }
            c('SEG_POINTER')                { |_| :pointer }
            c('SEG_TEMP')                   { |_| :temp }
        end

        finalize :explain => ENV.key?('DUMP_PARSER')

    end

end
