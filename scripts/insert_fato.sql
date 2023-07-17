create procedure insert_fato()
    language plpgsql
as
$$
begin
    insert
    into dbo.fato (sk_track,
                   sk_album,
                   sk_artist,
                   played_at,
                   data_carga)
    select dt.sk_track,
           da.sk_album,
           daa.sk_artist,
           to_timestamp(sf.played_at, 'yyyy/mm/dd hh24:mi:ss'),
           to_date(sf.data_carga, 'dd/mm/yyyy')
    from stage.stg_fato sf
             join dbo.dim_track dt on
        sf.track_id = dt.id
             join dbo.dim_album da on
        sf.album_id = da.id
             join dbo.dim_artist daa on
        sf.artist_id = daa.id
    ON conflict do nothing;
end;

$$;
