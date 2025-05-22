let () =
  let _ = Llvm_executionengine.initialize () in
  let context = Llvm.global_context () in
  let module_ = Llvm.create_module context "module" in
  let f_ty = Llvm.function_type (Llvm.i32_type context) [||] in
  let f = Llvm.define_function "main" f_ty module_ in
  let entry = Llvm.entry_block f in
  let builder = Llvm.builder_at_end context entry in
  ignore (Llvm.build_ret (Llvm.const_int (Llvm.i32_type context) 0) builder);
  Llvm.dump_module module_
