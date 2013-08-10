require 'rgen/metamodel_builder'

module RubyMM

	class Value < RGen::MetamodelBuilder::MMBase
	end

	class Block < Value
		has_many 'contents', Value
	end 

	class Call < Value
		has_attr 'name', String
		has_many 'args', Value
		has_one 'receiver', Value
		has_attr 'implicit_receiver', Boolean
	end

	class Def < Value
		has_attr 'name', String
		has_one 'body', Value
	end

	class Literal < Value
	end

	class BooleanLiteral < Literal
		has_attr 'value', Boolean
	end

	class IntLiteral < Literal
		has_attr 'value', Integer
	end

	class StringLiteral < Literal
		has_attr 'value', String
	end

	class NilLiteral < Literal
	end

	class Constant < Value
		has_attr 'name', String
		has_one 'container',Constant
	end

	class ClassDecl < RGen::MetamodelBuilder::MMBase
		has_one 'defname', Constant
		has_one 'super_class',Constant
		has_many 'body',Value
	end

	class Symbol < Value
		has_attr 'name', String
	end

	class LocalVarAssignment < Value
	end

	class LocalVarAccess < Value
	end

end