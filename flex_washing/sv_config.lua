sv_config = {}

sv_config.dirtMoney = 'black_money'
sv_config.doors = {
    [1] = {
        door = vec4(965.05633544922,-541.63916015625,59.895439147949, 208.25036621094), -- Coords of the door where you knock
        ped = {coords = vector4(965.21539306641, -541.86810302734, 59.727375030518, 208.25036621094), model = 'a_m_y_bevhills_02'}, -- Ped who opens door
        time = { -- Time when you can wash or false to disable -> 24/7
            min = 0,
            max = 8,
        },
        maxWash = 100000, -- Max amount of dirt money you can wash
        percent = math.random(20,30), -- How much % it takes from what you are washing
        dropofflocations = {
            {coords = vector4(1669.3724365234, -63.358787536621, 173.47471618652, 255.50094604492), car = 'jugular', peds = {'csb_g', 'a_m_y_eastsa_01', 'cs_dom', 'g_m_y_korean_01'}},
            {coords = vector4(909.07098388672, -3208.1186523438, 5.4833912849426, 180.619140625), car = 'jugular', peds = {'a_f_y_hippie_01', 'csb_hao', 'g_m_y_famfor_01', 'u_m_o_taphillbilly'}},
            {coords = vector4(-1658.7192382812, -3127.5004882812, 13.574664115906, 328.61959838867), car = 'jugular', peds = {'a_m_m_eastsa_02', 'csb_ramp_mex', 'ig_claypain', 'a_m_m_og_boss_01'}},
            {coords = vector4(1944.6553955078, 4627.3500976562, 40.052646636963, 345.83734130859), car = 'jugular', peds = {'csb_denise_friend', 'g_f_y_families_01', 'cs_dom', 'a_m_y_eastsa_01'}},
            {coords = vector4(1978.7727050781, 5171.9868164062, 47.221126556396, 129.60508728027), car = 'jugular', peds = {'csb_hao', 'a_m_m_eastsa_02', 'g_m_y_korean_01', 'csb_g'}},
            {coords = vector4(1900.9353027344, 4917.873046875, 48.34029006958, 11.430047035217), car = 'jugular', peds = {'u_m_o_taphillbilly', 'a_f_y_hippie_01', 'ig_claypain', 'g_f_y_families_01'}},
            {coords = vector4(2486.3630371094, 4959.5346679688, 44.419132232666, 125.45288085938), car = 'jugular', peds = {'csb_ramp_mex', 'csb_denise_friend', 'a_m_m_og_boss_01', 'g_m_y_famfor_01'}},
            {coords = vector4(1904.6505126953, 565.30596923828, 175.40461730957, 240.67353820801), car = 'jugular', peds = {'cs_dom', 'csb_g', 'a_m_m_eastsa_02', 'a_f_y_hippie_01'}},
            {coords = vector4(1686.5816650391, -1705.9614257812, 112.11780548096, 187.84663391113), car = 'jugular', peds = {'g_m_y_korean_01', 'u_m_o_taphillbilly', 'csb_hao', 'g_m_y_famfor_01'}},
            {coords = vector4(483.89215087891, -3254.6447753906, 5.6539669036865, 298.73559570312), car = 'jugular', peds = {'ig_claypain', 'a_m_y_eastsa_01', 'csb_denise_friend', 'csb_ramp_mex'}},
            {coords = vector4(-28.269172668457, -1260.9035644531, 28.778675079346, 87.868675231934), car = 'jugular', peds = {'g_f_y_families_01', 'a_m_m_og_boss_01', 'cs_dom', 'csb_hao'}},
            {coords = vector4(-148.50302124023, -956.17944335938, 20.85943031311, 182.25325012207), car = 'jugular', peds = {'a_f_y_hippie_01', 'g_m_y_korean_01', 'csb_ramp_mex', 'csb_g'}},
            {coords = vector4(600.44622802734, -461.28146362305, 24.845561981201, 354.35986328125), car = 'jugular', peds = {'u_m_o_taphillbilly', 'ig_claypain', 'a_m_m_eastsa_02', 'g_m_y_famfor_01'}},
            {coords = vector4(854.71087646484, -953.82476806641, 25.863945007324, 48.761825561523), car = 'jugular', peds = {'csb_denise_friend', 'g_f_y_families_01', 'a_m_y_eastsa_01', 'a_m_m_og_boss_01'}},
            {coords = vector4(-821.14306640625, -1771.5526123047, 28.141954421997, 126.92182159424), car = 'jugular', peds = {'g_m_y_famfor_01', 'cs_dom', 'csb_g', 'ig_claypain'}},
            {coords = vector4(-454.8219909668, 1595.2102050781, 358.60897827148, 205.83766174316), car = 'jugular', peds = {'csb_ramp_mex', 'a_m_m_eastsa_02', 'a_f_y_hippie_01', 'csb_hao'}},
            {coords = vector4(-189.26530456543, 6533.232421875, 10.690698623657, 88.066703796387), car = 'jugular', peds = {'u_m_o_taphillbilly', 'g_m_y_korean_01', 'g_f_y_families_01', 'a_m_m_og_boss_01'}},
        }
    },
    [2] = {
        door = vec4(-453.00823974609,6336.6279296875,13.105757713318, 36.119457244873), -- Coords of the door where you knock
        ped = {coords = vector4(-453.0891418457, 6336.8823242188, 13.109377861023, 36.119457244873), model = 'cs_carbuyer'}, -- Ped who opens door
        time = { -- Time when you can wash or false to disable -> 24/7
            min = 4,
            max = 12,
        },
        maxWash = 100000, -- Max amount of dirt money you can wash
        percent = math.random(20,30), -- How much % it takes from what you are washing
        dropofflocations = {
            {coords = vector4(1669.3724365234, -63.358787536621, 173.47471618652, 255.50094604492), car = 'jugular', peds = {'csb_g', 'a_m_y_eastsa_01', 'cs_dom', 'g_m_y_korean_01'}},
            {coords = vector4(909.07098388672, -3208.1186523438, 5.4833912849426, 180.619140625), car = 'jugular', peds = {'a_f_y_hippie_01', 'csb_hao', 'g_m_y_famfor_01', 'u_m_o_taphillbilly'}},
            {coords = vector4(-1658.7192382812, -3127.5004882812, 13.574664115906, 328.61959838867), car = 'jugular', peds = {'a_m_m_eastsa_02', 'csb_ramp_mex', 'ig_claypain', 'a_m_m_og_boss_01'}},
            {coords = vector4(1944.6553955078, 4627.3500976562, 40.052646636963, 345.83734130859), car = 'jugular', peds = {'csb_denise_friend', 'g_f_y_families_01', 'cs_dom', 'a_m_y_eastsa_01'}},
            {coords = vector4(1978.7727050781, 5171.9868164062, 47.221126556396, 129.60508728027), car = 'jugular', peds = {'csb_hao', 'a_m_m_eastsa_02', 'g_m_y_korean_01', 'csb_g'}},
            {coords = vector4(1900.9353027344, 4917.873046875, 48.34029006958, 11.430047035217), car = 'jugular', peds = {'u_m_o_taphillbilly', 'a_f_y_hippie_01', 'ig_claypain', 'g_f_y_families_01'}},
            {coords = vector4(2486.3630371094, 4959.5346679688, 44.419132232666, 125.45288085938), car = 'jugular', peds = {'csb_ramp_mex', 'csb_denise_friend', 'a_m_m_og_boss_01', 'g_m_y_famfor_01'}},
            {coords = vector4(1904.6505126953, 565.30596923828, 175.40461730957, 240.67353820801), car = 'jugular', peds = {'cs_dom', 'csb_g', 'a_m_m_eastsa_02', 'a_f_y_hippie_01'}},
            {coords = vector4(1686.5816650391, -1705.9614257812, 112.11780548096, 187.84663391113), car = 'jugular', peds = {'g_m_y_korean_01', 'u_m_o_taphillbilly', 'csb_hao', 'g_m_y_famfor_01'}},
            {coords = vector4(483.89215087891, -3254.6447753906, 5.6539669036865, 298.73559570312), car = 'jugular', peds = {'ig_claypain', 'a_m_y_eastsa_01', 'csb_denise_friend', 'csb_ramp_mex'}},
            {coords = vector4(-28.269172668457, -1260.9035644531, 28.778675079346, 87.868675231934), car = 'jugular', peds = {'g_f_y_families_01', 'a_m_m_og_boss_01', 'cs_dom', 'csb_hao'}},
            {coords = vector4(-148.50302124023, -956.17944335938, 20.85943031311, 182.25325012207), car = 'jugular', peds = {'a_f_y_hippie_01', 'g_m_y_korean_01', 'csb_ramp_mex', 'csb_g'}},
            {coords = vector4(600.44622802734, -461.28146362305, 24.845561981201, 354.35986328125), car = 'jugular', peds = {'u_m_o_taphillbilly', 'ig_claypain', 'a_m_m_eastsa_02', 'g_m_y_famfor_01'}},
            {coords = vector4(854.71087646484, -953.82476806641, 25.863945007324, 48.761825561523), car = 'jugular', peds = {'csb_denise_friend', 'g_f_y_families_01', 'a_m_y_eastsa_01', 'a_m_m_og_boss_01'}},
            {coords = vector4(-821.14306640625, -1771.5526123047, 28.141954421997, 126.92182159424), car = 'jugular', peds = {'g_m_y_famfor_01', 'cs_dom', 'csb_g', 'ig_claypain'}},
            {coords = vector4(-454.8219909668, 1595.2102050781, 358.60897827148, 205.83766174316), car = 'jugular', peds = {'csb_ramp_mex', 'a_m_m_eastsa_02', 'a_f_y_hippie_01', 'csb_hao'}},
            {coords = vector4(-189.26530456543, 6533.232421875, 10.690698623657, 88.066703796387), car = 'jugular', peds = {'u_m_o_taphillbilly', 'g_m_y_korean_01', 'g_f_y_families_01', 'a_m_m_og_boss_01'}},
        }
    },
    [3] = {
        door = vec4(152.56802368164,2281.291015625,94.148170471191, 162.20361328125), -- Coords of the door where you knock
        ped = {coords = vector4(152.47668457031, 2280.9296875, 93.945381164551, 162.20361328125), model = 'a_f_y_bevhills_04'}, -- Ped who opens door
        time = { -- Time when you can wash or false to disable -> 24/7
            min = 14,
            max = 22,
        },
        maxWash = 100000, -- Max amount of dirt money you can wash
        percent = math.random(20,30), -- How much % it takes from what you are washing
        dropofflocations = {
            {coords = vector4(1669.3724365234, -63.358787536621, 173.47471618652, 255.50094604492), car = 'jugular', peds = {'csb_g', 'a_m_y_eastsa_01', 'cs_dom', 'g_m_y_korean_01'}},
            {coords = vector4(909.07098388672, -3208.1186523438, 5.4833912849426, 180.619140625), car = 'jugular', peds = {'a_f_y_hippie_01', 'csb_hao', 'g_m_y_famfor_01', 'u_m_o_taphillbilly'}},
            {coords = vector4(-1658.7192382812, -3127.5004882812, 13.574664115906, 328.61959838867), car = 'jugular', peds = {'a_m_m_eastsa_02', 'csb_ramp_mex', 'ig_claypain', 'a_m_m_og_boss_01'}},
            {coords = vector4(1944.6553955078, 4627.3500976562, 40.052646636963, 345.83734130859), car = 'jugular', peds = {'csb_denise_friend', 'g_f_y_families_01', 'cs_dom', 'a_m_y_eastsa_01'}},
            {coords = vector4(1978.7727050781, 5171.9868164062, 47.221126556396, 129.60508728027), car = 'jugular', peds = {'csb_hao', 'a_m_m_eastsa_02', 'g_m_y_korean_01', 'csb_g'}},
            {coords = vector4(1900.9353027344, 4917.873046875, 48.34029006958, 11.430047035217), car = 'jugular', peds = {'u_m_o_taphillbilly', 'a_f_y_hippie_01', 'ig_claypain', 'g_f_y_families_01'}},
            {coords = vector4(2486.3630371094, 4959.5346679688, 44.419132232666, 125.45288085938), car = 'jugular', peds = {'csb_ramp_mex', 'csb_denise_friend', 'a_m_m_og_boss_01', 'g_m_y_famfor_01'}},
            {coords = vector4(1904.6505126953, 565.30596923828, 175.40461730957, 240.67353820801), car = 'jugular', peds = {'cs_dom', 'csb_g', 'a_m_m_eastsa_02', 'a_f_y_hippie_01'}},
            {coords = vector4(1686.5816650391, -1705.9614257812, 112.11780548096, 187.84663391113), car = 'jugular', peds = {'g_m_y_korean_01', 'u_m_o_taphillbilly', 'csb_hao', 'g_m_y_famfor_01'}},
            {coords = vector4(483.89215087891, -3254.6447753906, 5.6539669036865, 298.73559570312), car = 'jugular', peds = {'ig_claypain', 'a_m_y_eastsa_01', 'csb_denise_friend', 'csb_ramp_mex'}},
            {coords = vector4(-28.269172668457, -1260.9035644531, 28.778675079346, 87.868675231934), car = 'jugular', peds = {'g_f_y_families_01', 'a_m_m_og_boss_01', 'cs_dom', 'csb_hao'}},
            {coords = vector4(-148.50302124023, -956.17944335938, 20.85943031311, 182.25325012207), car = 'jugular', peds = {'a_f_y_hippie_01', 'g_m_y_korean_01', 'csb_ramp_mex', 'csb_g'}},
            {coords = vector4(600.44622802734, -461.28146362305, 24.845561981201, 354.35986328125), car = 'jugular', peds = {'u_m_o_taphillbilly', 'ig_claypain', 'a_m_m_eastsa_02', 'g_m_y_famfor_01'}},
            {coords = vector4(854.71087646484, -953.82476806641, 25.863945007324, 48.761825561523), car = 'jugular', peds = {'csb_denise_friend', 'g_f_y_families_01', 'a_m_y_eastsa_01', 'a_m_m_og_boss_01'}},
            {coords = vector4(-821.14306640625, -1771.5526123047, 28.141954421997, 126.92182159424), car = 'jugular', peds = {'g_m_y_famfor_01', 'cs_dom', 'csb_g', 'ig_claypain'}},
            {coords = vector4(-454.8219909668, 1595.2102050781, 358.60897827148, 205.83766174316), car = 'jugular', peds = {'csb_ramp_mex', 'a_m_m_eastsa_02', 'a_f_y_hippie_01', 'csb_hao'}},
            {coords = vector4(-189.26530456543, 6533.232421875, 10.690698623657, 88.066703796387), car = 'jugular', peds = {'u_m_o_taphillbilly', 'g_m_y_korean_01', 'g_f_y_families_01', 'a_m_m_og_boss_01'}},
        }
    },
    [4] = {
        door = vec4(996.11553955078,-1486.7253417969,31.549753189087, 278.78497314453), -- Coords of the door where you knock
        ped = {coords = vector4(996.42907714844, -1486.8073730469, 31.512073516846, 278.78497314453), model = 'g_m_y_azteca_01'}, -- Ped who opens door
        time = { -- Time when you can wash or false to disable -> 24/7
            min = 12,
            max = 20,
        },
        maxWash = 100000, -- Max amount of dirt money you can wash
        percent = math.random(20,30), -- How much % it takes from what you are washing
        dropofflocations = {
            {coords = vector4(1669.3724365234, -63.358787536621, 173.47471618652, 255.50094604492), car = 'jugular', peds = {'csb_g', 'a_m_y_eastsa_01', 'cs_dom', 'g_m_y_korean_01'}},
            {coords = vector4(909.07098388672, -3208.1186523438, 5.4833912849426, 180.619140625), car = 'jugular', peds = {'a_f_y_hippie_01', 'csb_hao', 'g_m_y_famfor_01', 'u_m_o_taphillbilly'}},
            {coords = vector4(-1658.7192382812, -3127.5004882812, 13.574664115906, 328.61959838867), car = 'jugular', peds = {'a_m_m_eastsa_02', 'csb_ramp_mex', 'ig_claypain', 'a_m_m_og_boss_01'}},
            {coords = vector4(1944.6553955078, 4627.3500976562, 40.052646636963, 345.83734130859), car = 'jugular', peds = {'csb_denise_friend', 'g_f_y_families_01', 'cs_dom', 'a_m_y_eastsa_01'}},
            {coords = vector4(1978.7727050781, 5171.9868164062, 47.221126556396, 129.60508728027), car = 'jugular', peds = {'csb_hao', 'a_m_m_eastsa_02', 'g_m_y_korean_01', 'csb_g'}},
            {coords = vector4(1900.9353027344, 4917.873046875, 48.34029006958, 11.430047035217), car = 'jugular', peds = {'u_m_o_taphillbilly', 'a_f_y_hippie_01', 'ig_claypain', 'g_f_y_families_01'}},
            {coords = vector4(2486.3630371094, 4959.5346679688, 44.419132232666, 125.45288085938), car = 'jugular', peds = {'csb_ramp_mex', 'csb_denise_friend', 'a_m_m_og_boss_01', 'g_m_y_famfor_01'}},
            {coords = vector4(1904.6505126953, 565.30596923828, 175.40461730957, 240.67353820801), car = 'jugular', peds = {'cs_dom', 'csb_g', 'a_m_m_eastsa_02', 'a_f_y_hippie_01'}},
            {coords = vector4(1686.5816650391, -1705.9614257812, 112.11780548096, 187.84663391113), car = 'jugular', peds = {'g_m_y_korean_01', 'u_m_o_taphillbilly', 'csb_hao', 'g_m_y_famfor_01'}},
            {coords = vector4(483.89215087891, -3254.6447753906, 5.6539669036865, 298.73559570312), car = 'jugular', peds = {'ig_claypain', 'a_m_y_eastsa_01', 'csb_denise_friend', 'csb_ramp_mex'}},
            {coords = vector4(-28.269172668457, -1260.9035644531, 28.778675079346, 87.868675231934), car = 'jugular', peds = {'g_f_y_families_01', 'a_m_m_og_boss_01', 'cs_dom', 'csb_hao'}},
            {coords = vector4(-148.50302124023, -956.17944335938, 20.85943031311, 182.25325012207), car = 'jugular', peds = {'a_f_y_hippie_01', 'g_m_y_korean_01', 'csb_ramp_mex', 'csb_g'}},
            {coords = vector4(600.44622802734, -461.28146362305, 24.845561981201, 354.35986328125), car = 'jugular', peds = {'u_m_o_taphillbilly', 'ig_claypain', 'a_m_m_eastsa_02', 'g_m_y_famfor_01'}},
            {coords = vector4(854.71087646484, -953.82476806641, 25.863945007324, 48.761825561523), car = 'jugular', peds = {'csb_denise_friend', 'g_f_y_families_01', 'a_m_y_eastsa_01', 'a_m_m_og_boss_01'}},
            {coords = vector4(-821.14306640625, -1771.5526123047, 28.141954421997, 126.92182159424), car = 'jugular', peds = {'g_m_y_famfor_01', 'cs_dom', 'csb_g', 'ig_claypain'}},
            {coords = vector4(-454.8219909668, 1595.2102050781, 358.60897827148, 205.83766174316), car = 'jugular', peds = {'csb_ramp_mex', 'a_m_m_eastsa_02', 'a_f_y_hippie_01', 'csb_hao'}},
            {coords = vector4(-189.26530456543, 6533.232421875, 10.690698623657, 88.066703796387), car = 'jugular', peds = {'u_m_o_taphillbilly', 'g_m_y_korean_01', 'g_f_y_families_01', 'a_m_m_og_boss_01'}},
        }
    },
}