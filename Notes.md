Phx.Repo.all(from t in FDTag, left_join: up in assoc(t, :fd_feed), preload: :fd_feed)
Phx.Repo.all(from t in FDTag, left_join: up in assoc(t, :fd_feed), preload: :fd_feed, select: t, where: up.id ==
 1)

 Phx.Repo.all(from t in FDTag, left_join: up in assoc(t, :fd_feed), preload: :fd_feed, select: t, where: fragment("? IN (SELECT fd_tag_id FROM fd_feed_tags)", t.id))