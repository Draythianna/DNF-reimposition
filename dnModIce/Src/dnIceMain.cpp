// dnIceMain.cpp
//

#include <windows.h>
#include "../../dukeed/Unreal.h"

UObject* IceSpawnManager = nullptr;

struct ObjectCall_Parms
{
	UObject* object;
	BITFIELD ReturnValue;
};

void (*__fastcall UObject_DestroyActual)(void* _this, void *edx);
void __fastcall UObject_Destroy(void* _this, void* edx)
{
	if (_this == IceSpawnManager && IceSpawnManager != nullptr)
	{
		IceSpawnManager = nullptr;
	}

	UObject_DestroyActual(_this, edx);
}

void (*__fastcall AActor__eventSpawnedActual)(AActor* _this, void *edx);
void __fastcall AActor__eventSpawned(AActor* _this, void *edx)
{
	UObject* _object = (UObject*)_this;

	OutputDebugStringW(_object->GetName());

	if (wcsstr(_object->GetName(), TEXT("IceSpawnManager")))
	{
		IceSpawnManager = _object;
		AActor__eventSpawnedActual(_this, edx);
		return;
	}

	if (IceSpawnManager == nullptr)
	{
		AActor__eventSpawnedActual(_this, edx);
		return;
	}
	
	AActor__eventSpawnedActual(_this, edx);

	ObjectCall_Parms Params;
	Params.object = _object;
	Params.ReturnValue = 0;

	UFunction* function = IceSpawnManager->FindFunction(TEXT("PostEntitySpawn"), FALSE);
	IceSpawnManager->ProcessEvent(function, &Params);


	//OutputDebugStringW(_object->GetName());
	//OutputDebugStringW(TEXT("\n"));
}


void InitDNFHooks()
{
	MH_Initialize();

	

	if (MH_CreateHookApi(TEXT("engine.dll"), MAKEINTRESOURCEA(12968), AActor__eventSpawned, (LPVOID*)&AActor__eventSpawnedActual) != MH_OK) {
		_asm {
			int 3
		}
	}

	if (MH_CreateHookApi(TEXT("engine.dll"), MAKEINTRESOURCEA(5705), UObject_Destroy, (LPVOID*)&UObject_DestroyActual) != MH_OK) {
		_asm {
			int 3
		}
	}
	MH_EnableHook(MH_ALL_HOOKS);
}

BOOL WINAPI DllMain(
	HINSTANCE hinstDLL,  // handle to DLL module
	DWORD fdwReason,     // reason for calling function
	LPVOID lpReserved)  // reserved
{
	// Perform actions based on the reason for calling.
	switch (fdwReason)
	{
	case DLL_PROCESS_ATTACH:
	{
		InitDNFHooks();
	}
	break;

	case DLL_THREAD_ATTACH:
		// Do thread-specific initialization.
		break;

	case DLL_THREAD_DETACH:
		// Do thread-specific cleanup.
		break;

	case DLL_PROCESS_DETACH:
		// Perform any necessary cleanup.
		break;
	}
	return TRUE;  // Successful DLL_PROCESS_ATTACH.
}