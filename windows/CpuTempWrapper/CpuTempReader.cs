using System;
using System.Linq;
using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;
using LibreHardwareMonitor.Hardware;

public static class SystemMonitor
{
    private static readonly Computer _computer;
    private static readonly object _lock = new object();

    static SystemMonitor()
    {
        _computer = new Computer
        {
            IsCpuEnabled = true,
            IsGpuEnabled = true,
            IsMemoryEnabled = true,
            IsMotherboardEnabled = false,
            IsNetworkEnabled = false,
            IsStorageEnabled = false,
            IsControllerEnabled = false
        };

        _computer.Open();
        Console.WriteLine("[Init] System monitor initialized.");
    }

    /// <summary>
    /// Returns CPU temperature in Celsius, or -1 if unavailable
    /// </summary>
    [UnmanagedCallersOnly(EntryPoint = "getCpuTemperature", CallConvs = new[] { typeof(CallConvCdecl) })]
    public static double GetCpuTemperature()
    {
        lock (_lock)
        {
            try
            {
                foreach (var hardware in _computer.Hardware)
                {
                    if (hardware.HardwareType != HardwareType.Cpu)
                        continue;

                    hardware.Update();

                    // Priority 1: CPU Package
                    var temp = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Temperature && 
                                           s.Name.Contains("Package"))
                        ?.Value;
                    if (temp.HasValue) return temp.Value;

                    // Priority 2: Core Average
                    temp = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Temperature && 
                                           s.Name.Contains("Average"))
                        ?.Value;
                    if (temp.HasValue) return temp.Value;

                    // Priority 3: Core Max
                    temp = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Temperature && 
                                           s.Name.Contains("Max"))
                        ?.Value;
                    if (temp.HasValue) return temp.Value;

                    // Priority 4: Calculate average from individual cores
                    var coreTemps = hardware.Sensors
                        .Where(s => s.SensorType == SensorType.Temperature && 
                                   s.Name.StartsWith("CPU Core #") &&
                                   !s.Name.Contains("Distance") &&
                                   s.Value.HasValue)
                        .Select(s => s.Value.Value)
                        .ToList();

                    if (coreTemps.Any())
                        return coreTemps.Average();
                }

                return -1.0;
            }
            catch
            {
                return -1.0;
            }
        }
    }

    /// <summary>
    /// Returns CPU load percentage (0-100), or -1 if unavailable
    /// </summary>
    [UnmanagedCallersOnly(EntryPoint = "getCpuLoad", CallConvs = new[] { typeof(CallConvCdecl) })]
    public static double GetCpuLoad()
    {
        lock (_lock)
        {
            try
            {
                foreach (var hardware in _computer.Hardware)
                {
                    if (hardware.HardwareType != HardwareType.Cpu)
                        continue;

                    hardware.Update();

                    var load = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Load && 
                                           s.Name == "CPU Total")
                        ?.Value;

                    return load ?? -1.0;
                }

                return -1.0;
            }
            catch
            {
                return -1.0;
            }
        }
    }

    /// <summary>
    /// Returns GPU temperature in Celsius, or -1 if unavailable
    /// </summary>
    [UnmanagedCallersOnly(EntryPoint = "getGpuTemperature", CallConvs = new[] { typeof(CallConvCdecl) })]
    public static double GetGpuTemperature()
    {
        lock (_lock)
        {
            try
            {
                foreach (var hardware in _computer.Hardware)
                {
                    // Only discrete GPUs (skip Intel integrated)
                    if (hardware.HardwareType != HardwareType.GpuNvidia && 
                        hardware.HardwareType != HardwareType.GpuAmd)
                        continue;

                    hardware.Update();

                    var temp = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Temperature && 
                                           s.Name == "GPU Core")
                        ?.Value;

                    if (temp.HasValue)
                        return temp.Value;
                }

                return -1.0;
            }
            catch
            {
                return -1.0;
            }
        }
    }

    /// <summary>
    /// Returns GPU load percentage (0-100), or -1 if unavailable
    /// </summary>
    [UnmanagedCallersOnly(EntryPoint = "getGpuLoad", CallConvs = new[] { typeof(CallConvCdecl) })]
    public static double GetGpuLoad()
    {
        lock (_lock)
        {
            try
            {
                foreach (var hardware in _computer.Hardware)
                {
                    if (hardware.HardwareType != HardwareType.GpuNvidia && 
                        hardware.HardwareType != HardwareType.GpuAmd)
                        continue;

                    hardware.Update();

                    var load = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Load && 
                                           s.Name == "GPU Core")
                        ?.Value;

                    if (load.HasValue)
                        return load.Value;
                }

                return -1.0;
            }
            catch
            {
                return -1.0;
            }
        }
    }

    /// <summary>
    /// Returns memory used in GB, or -1 if unavailable
    /// </summary>
    [UnmanagedCallersOnly(EntryPoint = "getMemoryUsed", CallConvs = new[] { typeof(CallConvCdecl) })]
    public static double GetMemoryUsed()
    {
        lock (_lock)
        {
            try
            {
                foreach (var hardware in _computer.Hardware)
                {
                    if (hardware.HardwareType != HardwareType.Memory)
                        continue;

                    hardware.Update();

                    var memUsed = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Data && 
                                           s.Name == "Memory Used")
                        ?.Value;

                    return memUsed ?? -1.0;
                }

                return -1.0;
            }
            catch
            {
                return -1.0;
            }
        }
    }

    /// <summary>
    /// Returns total memory in GB, or -1 if unavailable
    /// </summary>
    [UnmanagedCallersOnly(EntryPoint = "getMemoryTotal", CallConvs = new[] { typeof(CallConvCdecl) })]
    public static double GetMemoryTotal()
    {
        lock (_lock)
        {
            try
            {
                foreach (var hardware in _computer.Hardware)
                {
                    if (hardware.HardwareType != HardwareType.Memory)
                        continue;

                    hardware.Update();

                    var memUsed = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Data && 
                                           s.Name == "Memory Used")
                        ?.Value;

                    var memAvail = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Data && 
                                           s.Name == "Memory Available")
                        ?.Value;

                    if (memUsed.HasValue && memAvail.HasValue)
                        return memUsed.Value + memAvail.Value;

                    return -1.0;
                }

                return -1.0;
            }
            catch
            {
                return -1.0;
            }
        }
    }

    /// <summary>
    /// Returns memory load percentage (0-100), or -1 if unavailable
    /// </summary>
    [UnmanagedCallersOnly(EntryPoint = "getMemoryLoad", CallConvs = new[] { typeof(CallConvCdecl) })]
    public static double GetMemoryLoad()
    {
        lock (_lock)
        {
            try
            {
                foreach (var hardware in _computer.Hardware)
                {
                    if (hardware.HardwareType != HardwareType.Memory)
                        continue;

                    hardware.Update();

                    var memLoad = hardware.Sensors
                        .FirstOrDefault(s => s.SensorType == SensorType.Load && 
                                           s.Name == "Memory")
                        ?.Value;

                    return memLoad ?? -1.0;
                }

                return -1.0;
            }
            catch
            {
                return -1.0;
            }
        }
    }

    /// <summary>
    /// Updates all hardware sensors at once (call before reading multiple values)
    /// </summary>
    [UnmanagedCallersOnly(EntryPoint = "updateSensors", CallConvs = new[] { typeof(CallConvCdecl) })]
    public static void UpdateSensors()
    {
        lock (_lock)
        {
            try
            {
                foreach (var hardware in _computer.Hardware)
                {
                    hardware.Update();
                }
            }
            catch
            {
                // Silent fail
            }
        }
    }

    /// <summary>
    /// Cleanup method (optional, call when app closes)
    /// </summary>
    public static void Cleanup()
    {
        _computer?.Close();
        Console.WriteLine("[Cleanup] System monitor closed.");
    }
}