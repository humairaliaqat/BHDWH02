USE [master]
GO
/****** Object:  Database [db-au-star]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE DATABASE [db-au-star]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'db-au-star', FILENAME = N'H:\SQLData\db-au-star.mdf' , SIZE = 285374464KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB )
 LOG ON 
( NAME = N'db-au-star_log', FILENAME = N'F:\SQLLog\db-au-star_log.ldf' , SIZE = 6612544KB , MAXSIZE = 2048GB , FILEGROWTH = 1048576KB )
GO
ALTER DATABASE [db-au-star] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [db-au-star].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [db-au-star] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [db-au-star] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [db-au-star] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [db-au-star] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [db-au-star] SET ARITHABORT OFF 
GO
ALTER DATABASE [db-au-star] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [db-au-star] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [db-au-star] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [db-au-star] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [db-au-star] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [db-au-star] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [db-au-star] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [db-au-star] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [db-au-star] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [db-au-star] SET  DISABLE_BROKER 
GO
ALTER DATABASE [db-au-star] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [db-au-star] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [db-au-star] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [db-au-star] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [db-au-star] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [db-au-star] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [db-au-star] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [db-au-star] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [db-au-star] SET  MULTI_USER 
GO
ALTER DATABASE [db-au-star] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [db-au-star] SET DB_CHAINING OFF 
GO
ALTER DATABASE [db-au-star] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [db-au-star] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [db-au-star] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [db-au-star] SET QUERY_STORE = OFF
GO
USE [db-au-star]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE [db-au-star] SET  READ_WRITE 
GO
