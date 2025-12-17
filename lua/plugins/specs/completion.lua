-- Completion plugins: nvim-cmp, luasnip, snippets

return {
  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("plugins.configs.cmp")
    end,
  },

  {
    "hrsh7th/cmp-nvim-lsp",
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local f = ls.function_node
      local i = ls.insert_node
      local c = ls.choice_node

      -- Lorem ipsum generator
      local lorem_words = {
        "lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
        "sed", "do", "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore",
        "magna", "aliqua", "enim", "ad", "minim", "veniam", "quis", "nostrud",
        "exercitation", "ullamco", "laboris", "nisi", "aliquip", "ex", "ea", "commodo",
        "consequat", "duis", "aute", "irure", "in", "reprehenderit", "voluptate",
        "velit", "esse", "cillum", "fugiat", "nulla", "pariatur", "excepteur", "sint",
        "occaecat", "cupidatat", "non", "proident", "sunt", "culpa", "qui", "officia",
        "deserunt", "mollit", "anim", "id", "est", "laborum"
      }

      local function generate_lorem(count)
        local words = {}
        for idx = 1, count do
          table.insert(words, lorem_words[(idx - 1) % #lorem_words + 1])
        end
        return table.concat(words, " ")
      end

      ls.add_snippets("all", {
        s("lorem10", f(function() return generate_lorem(10) end)),
        s("lorem20", f(function() return generate_lorem(20) end)),
        s("lorem50", f(function() return generate_lorem(50) end)),
        s("lorem100", f(function() return generate_lorem(100) end)),
        s("lorem200", f(function() return generate_lorem(200) end)),
        s("lorem500", f(function() return generate_lorem(500) end)),
      })

      -- Java/Spring Boot snippets
      ls.add_snippets("java", {
        s("sout", { t("System.out.println("), i(1, '"message"'), t(");") }),
        s("psvm", { t({ "public static void main(String[] args) {", "  " }), i(0), t({ "", "}" }) }),
        s("log", { t("log."), c(1, { t("info"), t("debug"), t("warn"), t("error") }), t('("'), i(2, "message"), t('");') }),

        -- Spring Boot Controller
        s("controller", {
          t({ "@RestController", '@RequestMapping("/api/' }), i(1, "resource"),
          t({ '")', "public class " }), i(2, "Controller"),
          t({ " {", "", "  @Autowired", "  private " }), i(3, "Service"),
          t({ " service;", "", "  " }), i(0), t({ "", "}" }),
        }),

        -- Spring Boot Service
        s("service", {
          t({ "@Service", "public class " }), i(1, "Service"),
          t({ " {", "", "  @Autowired", "  private " }), i(2, "Repository"),
          t({ " repository;", "", "  " }), i(0), t({ "", "}" }),
        }),

        -- Spring Boot Repository
        s("repo", {
          t({ "@Repository", "public interface " }), i(1, "Repository"),
          t(" extends JpaRepository<"), i(2, "Entity"), t(", "), i(3, "Long"),
          t({ "> {", "  " }), i(0), t({ "", "}" }),
        }),

        -- JPA Entity
        s("entity", {
          t({ "@Entity", '@Table(name = "' }), i(1, "table_name"),
          t({ '")', "public class " }), i(2, "Entity"),
          t({ " {", "", "  @Id", "  @GeneratedValue(strategy = GenerationType.IDENTITY)", "  private Long id;", "", "  " }),
          i(0), t({ "", "}" }),
        }),

        -- REST Mappings
        s("@rest", t("@RestController")),
        s("@get", { t('@GetMapping("'), i(1, "/path"), t('")') }),
        s("@post", { t('@PostMapping("'), i(1, "/path"), t('")') }),
        s("@put", { t('@PutMapping("'), i(1, "/path"), t('")') }),
        s("@delete", { t('@DeleteMapping("'), i(1, "/path"), t('")') }),
        s("@patch", { t('@PatchMapping("'), i(1, "/path"), t('")') }),

        s("@getmap", {
          t({ '@GetMapping("' }), i(1, "/{id}"), t({ '")', "public ResponseEntity<" }), i(2, "Type"),
          t("> "), i(3, "method"), t("("), i(4), t({ ") {", "  " }), i(0), t({ "", "}" }),
        }),
        s("@postmap", {
          t({ "@PostMapping", "public ResponseEntity<" }), i(1, "Type"), t("> "), i(2, "method"),
          t("(@RequestBody "), i(3, "Dto"), t({ " dto) {", "  " }), i(0), t({ "", "}" }),
        }),
        s("@putmap", {
          t({ '@PutMapping("/{id}")', "public ResponseEntity<" }), i(1, "Type"), t("> "), i(2, "update"),
          t("(@PathVariable Long id, @RequestBody "), i(3, "Dto"), t({ " dto) {", "  " }), i(0), t({ "", "}" }),
        }),
        s("@delmap", {
          t({ '@DeleteMapping("/{id}")', "public ResponseEntity<Void> " }), i(1, "delete"),
          t({ "(@PathVariable Long id) {", "  " }), i(0), t({ "", "  return ResponseEntity.noContent().build();", "}" }),
        }),

        -- Spring annotations
        s("@auto", t("@Autowired")),
        s("@req", t("@RequestBody")),
        s("@path", { t("@PathVariable "), i(1, "Long"), t(" "), i(2, "id") }),
        s("@param", { t("@RequestParam "), i(1, "String"), t(" "), i(2, "param") }),
        s("@valid", t("@Valid")),

        -- Lombok
        s("@data", t("@Data")),
        s("@getter", t("@Getter")),
        s("@setter", t("@Setter")),
        s("@noargs", t("@NoArgsConstructor")),
        s("@allargs", t("@AllArgsConstructor")),
        s("@builder", t("@Builder")),
        s("@slf4j", t("@Slf4j")),

        -- Testing
        s("@test", { t({ "@Test", "void " }), i(1, "testMethod"), t({ "() {", "  " }), i(0), t({ "", "}" }) }),
        s("@boot", t("@SpringBootTest")),
      })
    end,
  },

  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },

  {
    "saadparwaiz1/cmp_luasnip",
  },
}
