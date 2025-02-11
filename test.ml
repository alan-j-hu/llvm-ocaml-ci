let () =
  let context = Llvm.global_context () in
  let module_ = Llvm.create_module context "module" in
  Llvm.dump_module module_
