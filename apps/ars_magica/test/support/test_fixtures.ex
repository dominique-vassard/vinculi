defmodule ArsMagica.TestFixtures do

  def add_fixtures() do
    Ecto.Adapters.SQL.query!(ArsMagica.Repo, "TRUNCATE taxonomy_term_data")
    taxonomy = %ArsMagica.Taxonomy{tid: 115, vid: 3,
                                   name: "Balibar Françoise",
                                   description: "<p class='rtejustify'>Physicienne et historienne des sciences française</p>",
                                   format: "full_html",
                                   weight: 0}

    ArsMagica.Repo.insert!(taxonomy)
  end
end