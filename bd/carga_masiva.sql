-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-04-2025 a las 10:52:09
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `carga_masiva`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `migrar_datos` ()   BEGIN
    -- 1. Migrar a personas (usando INSERT IGNORE para evitar duplicados)
    INSERT IGNORE INTO personas (nombre, paterno, materno)
    SELECT DISTINCT nombre, paterno, materno 
    FROM temp_excel_data;
    
    -- 2. Migrar teléfonos (referencia explícita)
    INSERT INTO telefonos (persona_id, numero)
    SELECT p.id, t.telefono
    FROM temp_excel_data t
    JOIN personas p ON t.nombre = p.nombre AND t.paterno = p.paterno
    WHERE t.telefono IS NOT NULL AND t.telefono != '';
    
    -- 3. Migrar direcciones
    INSERT INTO direcciones (persona_id, calle, numero_ext, numero_int, colonia, cp)
    SELECT p.id, t.calle, t.numero_exterior, t.numero_interior, t.colonia, t.cp
    FROM temp_excel_data t
    JOIN personas p ON t.nombre = p.nombre AND t.paterno = p.paterno;
    
    -- 4. Limpiar temporal (opcional)
    TRUNCATE TABLE temp_excel_data;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones`
--

CREATE TABLE `direcciones` (
  `id` int(11) NOT NULL,
  `persona_id` int(11) NOT NULL,
  `calle` varchar(255) NOT NULL,
  `numero_ext` varchar(20) NOT NULL,
  `numero_int` varchar(20) DEFAULT NULL,
  `colonia` varchar(255) NOT NULL,
  `cp` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `direcciones`
--

INSERT INTO `direcciones` (`id`, `persona_id`, `calle`, `numero_ext`, `numero_int`, `colonia`, `cp`) VALUES
(1, 1, 'Reforma', '123', 'A', 'Centro', '01000'),
(2, 2, 'Reforma', '123', 'A', 'Centro', '01000'),
(4, 2, 'Reforma', '123', 'A', 'Centro', '01000'),
(5, 5, 'Tlatelolco', '123', 'A', 'Centro', '01000'),
(6, 6, 'Gustavo A Madero', '5030', 'A', 'Panamericana', '07770');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2025_04_22_221411_add_is_admin_to_users_table', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 2, 'API_TOKEN', 'e7709c7024ee5cb476264fde6599ce4cc4550a7e4cd6de7f29742497acce4d50', '[\"*\"]', NULL, NULL, '2025-04-23 03:28:28', '2025-04-23 03:28:28'),
(2, 'App\\Models\\User', 2, 'API_TOKEN', 'cdaa7b0c8c35b999e38efec5268d133e47c10d7150ea480076420fccd2fd61ba', '[\"*\"]', NULL, NULL, '2025-04-23 03:32:52', '2025-04-23 03:32:52'),
(3, 'App\\Models\\User', 2, 'API_TOKEN', '738d809a4719bc951d44026fbce8e65a48ef77bed198a5d67f7c887a95f6dd4a', '[\"*\"]', NULL, NULL, '2025-04-23 04:16:32', '2025-04-23 04:16:32'),
(4, 'App\\Models\\User', 2, 'API_TOKEN', 'e61e06cdcc5eec939f6fea51fe8dd7d525ce9991a919b81afbdb7d9e74ea8fc4', '[\"*\"]', NULL, NULL, '2025-04-23 04:28:23', '2025-04-23 04:28:23'),
(5, 'App\\Models\\User', 2, 'API_TOKEN', '0e66940a3ebd39f445e4dcdb8167b056c8158332360f7f85b91afd8f6aa47f95', '[\"*\"]', NULL, NULL, '2025-04-23 04:41:03', '2025-04-23 04:41:03'),
(6, 'App\\Models\\User', 1, 'API_TOKEN', '25db4af6098f76eaafbaff2e70bedde59623ca88bed33256297a838c641cd493', '[\"*\"]', NULL, NULL, '2025-04-23 21:36:04', '2025-04-23 21:36:04'),
(7, 'App\\Models\\User', 1, 'API_TOKEN', 'e2774c8edc02322aac5681c20f022ce24de53548e6368a637e5fe74d4922149e', '[\"*\"]', NULL, NULL, '2025-04-23 21:36:20', '2025-04-23 21:36:20'),
(8, 'App\\Models\\User', 1, 'API_TOKEN', '101b9777f60e6b467c8cd3fe45b5b4ab7f48ae963e9438e982bd27d5f00afaf2', '[\"*\"]', NULL, NULL, '2025-04-23 21:38:13', '2025-04-23 21:38:13'),
(9, 'App\\Models\\User', 2, 'API_TOKEN', 'f49365e04825fd64e45cb8668434db284ad35844648293e8c9d385e0d2d7ede0', '[\"*\"]', NULL, NULL, '2025-04-23 21:38:50', '2025-04-23 21:38:50'),
(10, 'App\\Models\\User', 2, 'API_TOKEN', 'cba8c1b9c039ce12423dd800238ddfc7e0a36a6f8dbb9733f7b22afb2ecc607c', '[\"*\"]', NULL, NULL, '2025-04-23 21:44:15', '2025-04-23 21:44:15'),
(11, 'App\\Models\\User', 2, 'API_TOKEN', '5b27731bda32656dca22e045f3d8e821df2525b34089a045c1b7756d1d39a0dc', '[\"*\"]', NULL, NULL, '2025-04-23 21:47:46', '2025-04-23 21:47:46'),
(12, 'App\\Models\\User', 2, 'API_TOKEN', 'b756a1cac8f9cb3c9770b8c7a12a3a9d7a10100c489435d13c130bef27a22591', '[\"*\"]', NULL, NULL, '2025-04-23 21:51:13', '2025-04-23 21:51:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `paterno` varchar(255) NOT NULL,
  `materno` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`id`, `nombre`, `paterno`, `materno`, `created_at`) VALUES
(1, 'Juan', 'Pérez', 'López', '2025-04-22 19:41:11'),
(2, 'Luis', 'Pérez', 'López', '2025-04-22 19:41:11'),
(5, 'Graciela', 'Ramón', 'Rodriguez', '2025-04-22 23:20:12'),
(6, 'Giovanny', 'Valencia', 'Velazquez', '2025-04-23 16:34:51');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `telefonos`
--

CREATE TABLE `telefonos` (
  `id` int(11) NOT NULL,
  `persona_id` int(11) NOT NULL,
  `numero` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `telefonos`
--

INSERT INTO `telefonos` (`id`, `persona_id`, `numero`) VALUES
(1, 1, '5551234567'),
(2, 2, '5551234567'),
(4, 2, '5551234567'),
(5, 5, '5551234567'),
(6, 6, '5516778899');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `temp_excel_data`
--

CREATE TABLE `temp_excel_data` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `paterno` varchar(255) DEFAULT NULL,
  `materno` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `calle` varchar(255) DEFAULT NULL,
  `numero_exterior` varchar(50) DEFAULT NULL,
  `numero_interior` varchar(50) DEFAULT NULL,
  `colonia` varchar(255) DEFAULT NULL,
  `cp` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `is_admin`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@test.com', NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 0, NULL, '2025-04-22 20:49:06', '2025-04-22 20:49:06'),
(2, 'Usuario Test', 'test@example.com', NULL, '$2y$12$HCTiDN.2kYGm/q8XOf9RYOl8Cy3X8pnSx9IurCLLlIZsl8YHZIqJy', 1, NULL, '2025-04-23 03:27:00', '2025-04-23 04:15:53');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `persona_id` (`persona_id`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`,`paterno`);

--
-- Indices de la tabla `telefonos`
--
ALTER TABLE `telefonos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `persona_id` (`persona_id`);

--
-- Indices de la tabla `temp_excel_data`
--
ALTER TABLE `temp_excel_data`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `telefonos`
--
ALTER TABLE `telefonos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `temp_excel_data`
--
ALTER TABLE `temp_excel_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD CONSTRAINT `direcciones_ibfk_1` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `telefonos`
--
ALTER TABLE `telefonos`
  ADD CONSTRAINT `telefonos_ibfk_1` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
