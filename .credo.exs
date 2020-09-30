checks = [
  {Credo.Check.Design.TagTODO, [exit_status: 0]},
  {Credo.Check.Design.TagFIXME, [exit_status: 0]}
]

%{
  configs: [
    %{
      name: "default",
      strict: true,
      checks: checks,
      files: %{
        excluded: [~r"/_build/", ~r"/deps/", ~r"/node_modules/", "test/"]
      }
    },
    %{
      name: "test",
      strict: true,
      files: %{
        included: ["test/"]
      },
      checks: [
        {Credo.Check.Readability.ModuleDoc, false}
        | checks
      ]
    }
  ]
}
