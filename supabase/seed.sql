insert into public.users_profile (id, display_name, bio, prompts, interests, age, gender, location)
values
  ('00000000-0000-0000-0000-000000000001', 'Alex', 'Love hiking', '["Best weekend? Mountains"]', '{hiking,coffee}', 29, 'woman', 'NYC'),
  ('00000000-0000-0000-0000-000000000002', 'Sam', 'Foodie + traveler', '["Ideal date? Farmers market"]', '{travel,food}', 31, 'man', 'NYC')
on conflict do nothing;

insert into public.preferences (user_id, min_age, max_age, max_distance_km, interested_in)
values
  ('00000000-0000-0000-0000-000000000001', 26, 36, 30, '{man,non-binary}'),
  ('00000000-0000-0000-0000-000000000002', 24, 35, 20, '{woman,non-binary}')
on conflict do nothing;
